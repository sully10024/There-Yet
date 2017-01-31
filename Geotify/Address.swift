import MapKit
import CoreLocation

class Address {
  let addressLabel: String
  let addressLineOne: String
  let addressLineTwo: String
  let addressCoordinate: CLLocationCoordinate2D

  
  init(newAddressArray: [String])
  {
    self.addressLabel = newAddressArray[0]
    self.addressLineOne = newAddressArray[1]
    self.addressLineTwo = newAddressArray[2]
    
    // for debugging:
    print ("\n**ADDRESS DEBUGGING**")
    print ("(ADDRESS successfully added to array)")
    print (addressLabel)
    print (addressLineOne)
    print (addressLineTwo)
    
    addressCoordinate = addressCoordianteSearch() //NEED TO FINISH THIS SEARCH METHOD (IT DOESN'T WORK)
  }
  
  func addressCoordianteSearch() -> CLLocationCoordinate2D! {
    var matchingItems: [MKMapItem] = [MKMapItem]()
    matchingItems.removeAll()
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = self.addressLineOne + " " + self.addressLineTwo
    
    let search = MKLocalSearch(request: request)
    var firstResultCoordinate: CLLocationCoordinate2D

    search.start(completionHandler: {(response, error) in
      firstResultCoordinate = (response?.mapItems[0].placemark.coordinate)!
    })
    return (firstResultCoordinate)
  }

  
  public func getAddressLabel() -> String {
    return self.addressLabel
  }
  
  public func getAddressLineOne() -> String {
    return self.addressLineOne
  }
  
  public func getAddressLineTwo() -> String {
    return self.addressLineTwo
  }
}
