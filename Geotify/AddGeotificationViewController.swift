import UIKit
import MapKit


protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String)
}

class AddGeotificationViewController: UITableViewController {

  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!
  @IBOutlet weak var radiusTextField: UITextField!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var searchText: UITextField!
  @IBOutlet weak var clearButton: UIBarButtonItem!
  
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
    
    @IBAction func textFieldReturn(_ sender: AnyObject) {
        _ = sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }
	
	@IBAction func clearSearch(_ sender: AnyObject) {
		mapView.removeAnnotations(mapView.annotations)
	}
	
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
					if error == nil{
						for item in response!.mapItems {
							self.matchingItems.append(item as MKMapItem)
							let annotation = MKPointAnnotation()
							annotation.coordinate = item.placemark.coordinate
							annotation.title = item.name
							self.mapView.addAnnotation(annotation)
						}
					}
					
        })
    }
}
