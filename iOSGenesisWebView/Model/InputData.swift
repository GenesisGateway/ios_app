//
//  InputData.swift
//  iOSGenesisWebView
//

import Foundation
import GenesisSwift

public struct InputData: DataProtocol {
    public var title: String
    public var value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}

class InputDataHelper {
    public static let inputDataDefault: [DataProtocol] = [
        InputData(title: "Transaction Id", value: "wev238f328nc" + String(arc4random_uniform(999999))),
        ValidatedInputData(title:"Amount", value: "1,234.56", regex: "[0-9]{1,3}(,[0-9]{3})*.[0-9]{0,3}"),
        PickerData(title:"Currency", value: "USD", items: Currencies.allCurrencies),
        InputData(title:"Customer Email", value: "john.doe@example.com"),
        InputData(title:"Customer Phone", value: "+11234567890"),
        InputData(title:"First Name", value: "John"),
        InputData(title:"Last Name", value: "Doe"),
        InputData(title:"Address 1", value: "23, Doestreet"),
        InputData(title:"Address 2", value: ""),
        InputData(title:"ZIP Code", value: "11923"),
        InputData(title:"City", value: "New York City"),
        InputData(title:"State", value: "NY"),
        PickerData(title:"Country", value: "United States", items: IsoCountries.allCountries),
        InputData(title:"Notification Url", value: "https://example.com/notification")]
    
    public class func convertInputDataToArray(inputArray: Array<DataProtocol>) -> Array<Dictionary<String, String>> {
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
    
    public class func convertArrayToInputData(inputArray: Array<Dictionary<String, String>>) -> Array<DataProtocol> {
        var array = Array<DataProtocol>()
        var counter = 0
        for dictionary in inputArray {
            if let title = dictionary["title"], let value = dictionary["value"], let regex = dictionary["regex"], let type = dictionary["type"] {
                if type == "InputData" {
                    array.append(InputData(title: title, value: value))
                }
                if type == "PickerData" {
                    if counter == 0 {
                        array.append(PickerData(title: title, value: value, items: Currencies.allCurrencies))
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
