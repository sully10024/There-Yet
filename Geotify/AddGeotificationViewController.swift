import UIKit
import MapKit
import CoreLocation
import AVFoundation

protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
    radius: Double, identifier: String, note: String)
}


class AddGeotificationViewController: UITableViewController {

    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var zoomButton: UIBarButtonItem!
    @IBOutlet weak var radiusSlider:  UISlider!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var unitsSwitcher: UISegmentedControl!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var recentSearchesScrollView: UIScrollView!
  
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var delegate: AddGeotificationsViewControllerDelegate?
    var isMetric = true
    
    var recentSearchesArray: [String] = []
    var lastSearch = ""

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
    }
    
    if unitsSwitcher.selectedSegmentIndex == 1 {
      isMetric = false
      radiusSlider.minimumValue = 60.96
      radiusSlider.maximumValue = 4828.03
      
      radiusSlider.value = radiusSlider.minimumValue
      updateRadiusLabel()
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
    
    @IBAction func searchFieldDidBeginEditing(_ sender: Any)
    {
        matchingItems.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        
        recentSearchesScrollView.isHidden = false
    }
    
    // Function for saving recent searches to long term storage, and removing the oldest
    func writeRecentSearchArray()
    {
        let defaults = UserDefaults.standard
        defaults.set(recentSearchesArray, forKey: "SavedRecentSearchesArray")
    }
    
    // Function for retreiving recent searches array from
    func readRecentSearchArray()
    {
        let defaults = UserDefaults.standard
        recentSearchesArray = defaults.stringArray(forKey: "SavedRecentSearchesArray")  ?? [String]()
    }
    
    // Function for checking how many items are in the recent searches array and removing the oldest one if necessary
    func checkRecentSearchArray()
    {
        let defaults = UserDefaults.standard
        var recentSearchesCheckArray = defaults.stringArray(forKey: "SavedRecentSearchesArray") ?? [String]()
        if (recentSearchesCheckArray.count > 5)
        {
            recentSearchesCheckArray.removeLast()
            defaults.set(recentSearchesCheckArray, forKey: "SavedRecentSearchesArray")
        }
        readRecentSearchArray()
    }
  
    // Add a search to the array after doing a search in the searchBar
    func addRecentSearchQueryToRecentSearchArray()
    {
        readRecentSearchArray()
        checkRecentSearchArray()
        recentSearchesArray.insert(lastSearch, at: 0)
        writeRecentSearchArray()
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
    
    @IBAction func textFieldDidReturn(_ sender: AnyObject) {
        _ = sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        recentSearchesScrollView.isHidden = true
        
        lastSearch = searchText.text!
        checkRecentSearchArray()
        
        addRecentSearchQueryToRecentSearchArray()
        
        print("DEBUGGING FOR RECENT SEARCH ARRAY")
        print(recentSearchesArray)
        
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
