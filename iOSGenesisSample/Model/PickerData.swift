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
        "\(name) - \(alpha2)"
    }
    
    public var pickerValue: String {
        name
    }
}

extension CurrencyInfo: PickerDataItem {
    public var pickerTitle: String {
        name.rawValue
    }
    
    public var pickerValue: String {
        name.rawValue
    }
}

struct EnumPickerItem: PickerDataItem {
    let pickerTitle: String
    let pickerValue: String

    init(_ item: String) {
        pickerTitle = item
        pickerValue = item
    }

    init(title: String, value: String) {
        pickerTitle = title
        pickerValue = value
    }
}

public final class PickerData: ObjectDataProtocol {
    public var title: String
    public var value: String
    public var items: [PickerDataItem]
    
    public init(title: String, value: String, items: [PickerDataItem]) {
        self.title = title
        self.value = value
        self.items = items
    }
}
