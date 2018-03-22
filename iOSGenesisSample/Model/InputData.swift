//
//  InputData.swift
//  iOSGenesisSample
//

import Foundation
import GenesisSwift

public class InputDataObject: DataProtocol {
    public var title: String
    public var value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}

public class InputData: NSObject {    
    var transactionId = InputDataObject(title: "Transaction Id", value: "wev238f328nc" + String(arc4random_uniform(999999)))
    var amount = ValidatedInputData(title:"Amount", value: "1234.56", regex: "^?\\d*(\\.\\d{0,3})?$")
    var currency = PickerData(title:"Currency", value: "USD", items: Currencies().allCurrencies)
    var usage = InputDataObject(title:"Usage", value: "Tickets")
    var customerEmail = ValidatedInputData(title:"Customer Email", value: "john.doe@example.com", regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    var customerPhone = InputDataObject(title:"Customer Phone", value: "+11234567890")
    var firstName = InputDataObject(title:"First Name", value: "John")
    var lastName = InputDataObject(title:"Last Name", value: "Doe")
    var address1 = InputDataObject(title:"Address 1", value: "23, Doestreet")
    var address2 = InputDataObject(title:"Address 2", value: "")
    var zipCode = InputDataObject(title:"ZIP Code", value: "11923")
    var city = InputDataObject(title:"City", value: "New York City")
    var state =  InputDataObject(title:"State", value: "NY")
    var country = PickerData(title:"Country", value: "United States", items: IsoCountries.allCountries)
    var notificationUrl = InputDataObject(title:"Notification Url", value: "https://example.com/notification")
    
    public var allObjects: [Any] {
        get {
            return [transactionId, amount, currency, usage, customerEmail, customerPhone, firstName, lastName, address1, address2, zipCode, city, state, country, notificationUrl]
        }
    }
    
    fileprivate let userDefaultsKey = "UserDefaultsDataKey"
    
    public override init() {
        super.init()
        
        guard let loaded = UserDefaults.standard.array(forKey: userDefaultsKey) else {
            save()
            return
        }
        
        let loadedInputDataSource = convertArrayToInputData(inputArray: loaded as! Array<Dictionary<String, String>>)
        
        for inputData in loadedInputDataSource {
            switch inputData.title {
            case "Transaction Id": continue
            case "Amount": amount = inputData as! ValidatedInputData
            case "Currency": currency = inputData as! PickerData
            case "Usage": usage = inputData as! InputDataObject
            case "Customer Email": customerEmail = inputData as! ValidatedInputData
            case "Customer Phone": customerPhone = inputData as! InputDataObject
            case "First Name": firstName = inputData as! InputDataObject
            case "Last Name": lastName = inputData as! InputDataObject
            case "Address 1": address1 = inputData as! InputDataObject
            case "Address 2": address2 = inputData as! InputDataObject
            case "ZIP Code": zipCode = inputData as! InputDataObject
            case "City": city = inputData as! InputDataObject
            case "State": state = inputData as! InputDataObject
            case "Country": country = inputData as! PickerData
            case "Notification Url": notificationUrl = inputData as! InputDataObject
                
            default: continue
            }
        }
    }
    
    func save() {
        UserDefaults.standard.set(convertInputDataToArray(inputArray:allObjects as! Array<DataProtocol>), forKey: userDefaultsKey)
    }
}

extension InputData {
    public func convertInputDataToArray(inputArray: Array<DataProtocol>) -> Array<Dictionary<String, String>> {
        var array = Array<Dictionary<String, String>>()
        for data in inputArray {
            var dictionary = Dictionary<String, String>()
            dictionary["title"] = data.title
            dictionary["value"] = data.value
            dictionary["regex"] = data.regex
            dictionary["type"] = String(describing: type(of: data))
            array.append(dictionary)
        }
        return array
    }
    
    public func convertArrayToInputData(inputArray: Array<Dictionary<String, String>>) -> Array<DataProtocol> {
        var array = Array<DataProtocol>()
        var counter = 0
        for dictionary in inputArray {
            if let title = dictionary["title"], let value = dictionary["value"], let regex = dictionary["regex"], let type = dictionary["type"] {
                if type == "InputDataObject" {
                    array.append(InputDataObject(title: title, value: value))
                }
                if type == "PickerData" {
                    if counter == 0 {
                        array.append(PickerData(title: title, value: value, items: Currencies().allCurrencies))
                    }
                    if counter == 1 {
                        array.append(PickerData(title: title, value: value, items: IsoCountries.allCountries))
                    }
                    counter += 1
                }
                if type == "ValidatedInputData" {
                    array.append(ValidatedInputData(title: title, value: value, regex: regex))
                }
            }
        }
        return array
    }
}
