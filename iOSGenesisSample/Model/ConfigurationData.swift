//
//  ConfigurationData.swift
//  iOSGenesisSample
//
//  Created by Ivaylo Hadzhiev on 26.01.23.
//

import Foundation
import GenesisSwift

public final class ConfigurationData: NSObject {

    private(set) lazy var username = InputDataObject(title: Titles.username.rawValue, value: "YOUR_USERNAME")
    private(set) lazy var password = InputDataObject(title: Titles.password.rawValue, value: "YOUR_PASSWORD")
    private(set) lazy var language =
        PickerData(title: Titles.language.rawValue, value: ConfigLanguage.en.rawValue, items: ConfigLanguage.allLanguages)
    private(set) lazy var environment =
        PickerData(title: Titles.environment.rawValue, value: ConfigEnvironment.staging.rawValue, items: ConfigEnvironment.allEnvironments)
    private(set) lazy var endpoint =
        PickerData(title: Titles.endpoint.rawValue, value: ConfigEndpoint.emerchantpay.rawValue, items: ConfigEndpoint.allEndpoints)

    var objects: [ObjectDataProtocol] {
        [username, password, language, environment, endpoint]
    }

    override init() {
        super.init()
        loadInputData()
    }

    func save() {
        let data = Storage.convertInputDataToArray(inputArray: objects)
        UserDefaults.standard.set(data, forKey: Storage.Keys.configuationData)
    }

    /** Creates Genesis configuration based on input data.
     */
    func createConfiguration() -> Configuration {
        let credentials = Credentials(withUsername: username.value, andPassword: password.value)

        let language = ConfigLanguage(rawValue: language.value).unwrap(error: "Invalid language: \(language.value)")
        let environment = ConfigEnvironment(rawValue: environment.value).unwrap(error: "Invalid environment: \(environment.value)")
        let endpoint = ConfigEndpoint(rawValue: endpoint.value).unwrap(error: "Invalid endpoint: \(endpoint.value)")
        return Configuration(credentials: credentials, language: language, environment: environment, endpoint: endpoint)
    }
}

private extension ConfigurationData {

    enum Titles: String {
        case username = "Username"
        case password = "Password"
        case language = "Language"
        case environment = "Environment"
        case endpoint = "Endpoint"
    }

    func loadInputData() {
        guard let storedData = UserDefaults.standard.array(forKey: Storage.Keys.configuationData) as? [[String: String]] else {
            save()
            return
        }
        
        let inputData = inputData(from: storedData)
        for data in inputData {
            switch Titles(rawValue: data.title) {
            case .username: username = data as! InputDataObject
            case .password: password = data as! InputDataObject
            case .language: language = data as! PickerData
            case .environment: environment = data as! PickerData
            case .endpoint: endpoint = data as! PickerData
            default:
                assertionFailure("Unknown title: \(data.title)")
            }
        }
    }

    func inputData(from inputArray: [[String: String]]) -> [GenesisSwift.DataProtocol] {
        var array = [GenesisSwift.DataProtocol]()
        for dictionary in inputArray {
            if let title = dictionary["title"],
                let value = dictionary["value"],
                let regex = dictionary["regex"],
               let rawType = dictionary["type"], let type = Storage.Types(rawValue: rawType) {

                switch type {
                case .dataObject:
                    array.append(InputDataObject(title: title, value: value))
                case .validatedData:
                    array.append(ValidatedInputData(title: title, value: value, regex: regex))
                case .pickerData:
                    switch Titles(rawValue: title) {
                    case .language:
                        array.append(PickerData(title: title, value: value, items: ConfigLanguage.allLanguages))
                    case .environment:
                        array.append(PickerData(title: title, value: value, items: ConfigEnvironment.allEnvironments))
                    case .endpoint:
                        array.append(PickerData(title: title, value: value, items: ConfigEndpoint.allEndpoints))
                    default:
                        assertionFailure("Unknown title: \(title)")
                        break
                    }
                }
            }
        }
        return array
    }
}

extension ConfigLanguage {
    static var allLanguages: [EnumPickerItem] {
        [EnumPickerItem(title: "English", value: ConfigLanguage.en.rawValue),
         EnumPickerItem(title: "Italian", value: ConfigLanguage.it.rawValue),
         EnumPickerItem(title: "Spanish", value: ConfigLanguage.es.rawValue),
         EnumPickerItem(title: "French", value: ConfigLanguage.fr.rawValue),
         EnumPickerItem(title: "German", value: ConfigLanguage.de.rawValue),
         EnumPickerItem(title: "Japanese", value: ConfigLanguage.ja.rawValue),
         EnumPickerItem(title: "Mandarin Chinese", value: ConfigLanguage.zh.rawValue),
         EnumPickerItem(title: "Arabic", value: ConfigLanguage.ar.rawValue),
         EnumPickerItem(title: "Portuguese", value: ConfigLanguage.pt.rawValue),
         EnumPickerItem(title: "Turkish", value: ConfigLanguage.tr.rawValue),
         EnumPickerItem(title: "Russian", value: ConfigLanguage.ru.rawValue),
         EnumPickerItem(title: "Hindu", value: ConfigLanguage.hi.rawValue),
         EnumPickerItem(title: "Bulgarian", value: ConfigLanguage.bg.rawValue)]
    }
}

extension ConfigEnvironment {
    static var allEnvironments: [EnumPickerItem] {
        [EnumPickerItem(title: "production", value: ConfigEnvironment.production.rawValue),
         EnumPickerItem(title: "staging", value: ConfigEnvironment.staging.rawValue)]
    }
}

extension ConfigEndpoint {
    static var allEndpoints: [EnumPickerItem] {
        [EnumPickerItem(title: "emerchantpay", value: ConfigEndpoint.emerchantpay.rawValue),
         EnumPickerItem(title: "e-comprocessing", value: ConfigEndpoint.ecomprocessing.rawValue)]
    }
}
