class Address {
  let addressLabel: String
  let addressLineOne: String
  let addressLineTwo: String
  
  init(addressLabel: String, addressLineOne: String, addressLineTwo: String)
  {
    self.addressLabel = addressLabel
    self.addressLineOne = addressLineOne
    self.addressLineTwo = addressLineTwo
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
