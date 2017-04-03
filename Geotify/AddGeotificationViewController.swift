import UIKit
import MapKit
import CoreLocation

protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
    radius: Double, identifier: String, note: String)
}

class AddGeotificationViewController: UITableViewController {

  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!
  @IBOutlet weak var radiusSlider: UISlider!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchText: UITextField!
  @IBOutlet weak var radiusLabel: UILabel!
  @IBOutlet weak var unitsSwitcher: UISegmentedControl!
  
  var matchingItems: [MKMapItem] = [MKMapItem]()
  var delegate: AddGeotificationsViewControllerDelegate?
  var isMetricView = true
  
  // m = 0, km = 1, ft = 2, mi = 3
  var unitsLabelOptions: [String] = ["m", "km", "ft", "mi"]
  
  let defaults = UserDefaults.standard

  override func viewDidLoad() {
    super.viewDidLoad()
    addButton.isEnabled = false
  }
  
  @IBAction func unitsSwitcherDidChange(_ sender: Any)
  {
    if unitsSwitcher.selectedSegmentIndex == 0 {
      isMetricView = true
    }
    
    if unitsSwitcher.selectedSegmentIndex == 1 {
      isMetricView = false
    }
  }
  
  
  // this function looks for a change in the radius slider
  // when there is a change, it then updates the text beside the slider
  @IBAction func radiusSliderDidChange(_ sender: Any) {
    let sliderValueAsMetersInt = Int(radiusSlider.value)
    if sliderValueAsMetersInt < 1000 {
      radiusLabel.text = "\(sliderValueAsMetersInt) m"
    } else {
      radiusLabel.text = (NSString(format: "%.1f", (radiusSlider.value)/1000) as String) + " km"
    }
    
    //radiusLabel.text = (NSString(format: "%.1f", radiusSlider.value) as String) + " m"
    //radiusLabel.text = "\(sliderValueAsInt)"
  }
  
  @IBAction func textFieldEditingChanged(sender: UITextField) {
    addButton.isEnabled = true
  }

  @IBAction func onCancel(sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction private func onAdd(sender: AnyObject) {
    let coordinate = mapView.centerCoordinate
    let radius = Double(String(format: "%.2f", radiusSlider.value))
    let identifier = NSUUID().uuidString
    let note = noteTextField.text
    delegate?.addGeotificationViewController(controller: self, didAddCoordinate: coordinate, radius: radius!, identifier: identifier, note: note!)
  }
  
  @IBAction func onZoomToCurrentLocation(_ sender: Any) {
    mapView.zoomToUserLocation()
  }
  
  // clears the search when the user starts editing in the searchBar
  @IBAction func onClearMapSearch(_ sender: Any) {
    matchingItems.removeAll()
    mapView.removeAnnotations(mapView.annotations)
  }
  
  @IBAction func textFieldDidReturn(_ sender: AnyObject) {
    _ = sender.resignFirstResponder()
    mapView.removeAnnotations(mapView.annotations)
    self.performSearch()
  }
  
  
  // method for doing a search
  func performSearch() {
    
    matchingItems.removeAll()
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = searchText.text
    request.region = mapView.region
    
    let search = MKLocalSearch(request: request)
    
    var hasIteratedFirstItem = false // this is so that it only zooms to the first result
    
    search.start(completionHandler: {(response, error) in
      
      if error != nil {
        print("Error occured in search: \(error!.localizedDescription)")
      } else if response!.mapItems.count == 0 {
        print("No matches found")
      } else {
        print("Matches found")
        
        for item in response!.mapItems {
          // this if block zooms to the first result
          if hasIteratedFirstItem == false
          {
            let newMapCenter = item.placemark.coordinate
            let newMapRegion = MKCoordinateRegionMakeWithDistance(newMapCenter, 10000,10000)
            
            self.mapView.setRegion(newMapRegion, animated:true)
            
            hasIteratedFirstItem = true
          }
          
          print("Name = \(item.name)")
          print("Phone = \(item.phoneNumber)")
          
          self.matchingItems.append(item as MKMapItem)
          print("Matching items = \(self.matchingItems.count)")
          
          let annotation = MKPointAnnotation()
          annotation.coordinate = item.placemark.coordinate
          annotation.title = item.name
          self.mapView.addAnnotation(annotation)
        }
      }
    })
  }
}
