//
//  ValidatedInputData.swift
//  iOSGenesisWebView
//

import Foundation
import GenesisSwift

public struct ValidatedInputData: DataProtocol {
    public var title: String
    public var value: String
    public var regex: String
    
    public init(title: String, value: String, regex: String) {
        self.title = title
        self.value = value
        self.regex = regex
    }
}
