//
//  PickerData.swift
//  iOSGenesisSample
//

import Foundation
import GenesisSwift

public protocol PickerDataItem {
    var pickerTitle: String { get }
    var pickerValue: String { get }
}

extension IsoCountryInfo: PickerDataItem {
    public var pickerTitle: String {
        return "\(self.name) - \(self.alpha2)"
    }
    
    public var pickerValue: String {
        return self.name
    }
}

extension CurrencyInfo: PickerDataItem {
    public var pickerTitle: String {
        return self.name.rawValue
    }
    
    public var pickerValue: String {
        return self.name.rawValue
    }
}

public class PickerData: DataProtocol {
    public var title: String
    public var value: String
    public var items: [PickerDataItem]
    
    public init(title: String, value: String, items: [PickerDataItem]) {
        self.title = title
        self.value = value
        self.items = items
    }
}
