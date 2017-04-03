import UIKit
import MapKit
import CoreLocation
import AVFoundation

protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
    radius: Double, identifier: String, note: String)
}

var audioPlayer:AVAudioPlayer!
var audioFilePath = Bundle.main.path(forResource: "sanic", ofType: "mp3")

class AddGeotificationViewController: UITableViewController {

  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!
  @IBOutlet weak var radiusSlider: UISlider!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchText: UITextField!
  @IBOutlet weak var radiusLabel: UILabel!
  @IBOutlet weak var unitsSwitcher: UISegmentedControl!
  @IBOutlet weak var sanicPic: UIImageView!
  
  var matchingItems: [MKMapItem] = [MKMapItem]()
  var delegate: AddGeotificationsViewControllerDelegate?
  var isMetric = true
  
  let defaults = UserDefaults.standard

  override func viewDidLoad() {
    super.viewDidLoad()
    addButton.isEnabled = false
  }
  
  @IBAction func unitsSwitcherDidChange(_ sender: Any)
  {
    if unitsSwitcher.selectedSegmentIndex == 0 {
      isMetric = true
      radiusSlider.minimumValue = 50
      radiusSlider.maximumValue = 5000
      
      radiusSlider.value = radiusSlider.minimumValue
      updateRadiusLabel()
      
      stopSanic()
    }
    
    if unitsSwitcher.selectedSegmentIndex == 1 {
      isMetric = false
      radiusSlider.minimumValue = 60.96
      radiusSlider.maximumValue = 4828.03
      
      radiusSlider.value = radiusSlider.minimumValue
      updateRadiusLabel()
      startSanic()
    }
  }
  
  @IBAction func radiusSliderDidChange(_ sender: Any) {
    updateRadiusLabel()
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
  
  func updateRadiusLabel()
  {
    if isMetric {
      if radiusSlider.value < 1000 {
        radiusLabel.text = "\(Int(radiusSlider.value)) m"
      } else {
        radiusLabel.text = (NSString(format: "%.1f", (radiusSlider.value)/1000) as String) + " km"
      }
      
    } else if !isMetric {
      let sliderValueAsFeet = radiusSlider.value * 3.28084
      if sliderValueAsFeet < 5280 {
        radiusLabel.text = "\(Int(sliderValueAsFeet)) ft"
      } else {
        radiusLabel.text = (NSString(format: "%.1f", (sliderValueAsFeet)/5280) as String) + " mi"
      }
    }
  }
  
  func startSanic() {
    
    if audioFilePath != nil {
      
      let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
      do {
        try audioPlayer = AVAudioPlayer(contentsOf: audioFileUrl)
        audioPlayer.play()
      } catch {
        print("oops")
      }
    }
    
    sanicPic.isHidden = false
    noteTextField.placeholder = "gotTA GO AFST!!!"
  }
  
  func stopSanic() {
    audioPlayer.stop()
    sanicPic.isHidden = true
    noteTextField.placeholder = "Reminder note to be shown"
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
