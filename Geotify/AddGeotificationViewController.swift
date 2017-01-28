import UIKit
import MapKit

protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
    radius: Double, identifier: String, note: String)
}

class AddGeotificationViewController: UITableViewController {

  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!
  @IBOutlet weak var radiusTextField: UITextField!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchBar: UITextField!
  @IBOutlet weak var clearButton: UIBarButtonItem!
  @IBOutlet weak var searchText: UITextField!
  
  var matchingItems: [MKMapItem] = [MKMapItem]()
  var delegate: AddGeotificationsViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    //navigationItem.rightBarButtonItems = [addButton, zoomButton]
    addButton.isEnabled = false
  }

  @IBAction func textFieldEditingChanged(sender: UITextField) {
    addButton.isEnabled = !radiusTextField.text!.isEmpty && !noteTextField.text!.isEmpty
  }

  @IBAction func onCancel(sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction private func onAdd(sender: AnyObject) {
    let coordinate = mapView.centerCoordinate
    let radius = Double(radiusTextField.text!) ?? 0
    let identifier = NSUUID().uuidString
    let note = noteTextField.text
    delegate?.addGeotificationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!)
  }
  
  @IBAction func onZoomToCurrentLocation(_ sender: Any) {
    mapView.zoomToUserLocation()
  }
  
  // clears the map search when the clear search button is pressed
  @IBAction func onClearMapSearch(_ sender: UIBarButtonItem) {
    matchingItems.removeAll()
    mapView.removeAnnotations(mapView.annotations)
  }
  
  //IBAction for the read the searchbar
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
