//
//  Storage.swift
//  iOSGenesisSample
//
//  Created by Ivaylo Hadzhiev on 26.01.23.
//

import Foundation
import GenesisSwift

enum Storage {

    enum Types: String {
        case dataObject = "InputDataObject"
        case pickerData = "PickerData"
        case validatedData = "ValidatedInputData"
    }

    enum Keys {
        static let configuationData = "UserDefaultsConfigurationDataKey"
        static let commonData = "UserDefaultsDataKey"
    }

    static func convertInputDataToArray(inputArray: [GenesisSwift.DataProtocol]) -> [[String: String]] {
        var array = [[String: String]]()
        for data in inputArray {
            var dictionary = [String: String]()
            dictionary["title"] = data.title
            dictionary["value"] = data.value
            dictionary["regex"] = data.regex
            dictionary["type"] = String(describing: type(of: data))
            array.append(dictionary)
        }
        return array
    }
}
