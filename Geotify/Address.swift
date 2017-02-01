import MapKit
import CoreLocation

class Address {
  let addressLabel: String
  let addressLineOne: String
  let addressLineTwo: String

  
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
  
  public func getFullAddressAsString() -> String {
    let fullAddressAsString = addressLineOne + " " + addressLineTwo
    
    return fullAddressAsString
  }
}
