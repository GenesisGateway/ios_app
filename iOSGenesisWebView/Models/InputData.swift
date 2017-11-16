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
