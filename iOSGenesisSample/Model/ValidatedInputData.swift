//
//  ValidatedInputData.swift
//  iOSGenesisSample
//

import Foundation

public final class ValidatedInputData: ObjectDataProtocol {
    public var title: String
    public var value: String
    public var regex: String
    
    public init(title: String, value: String, regex: String) {
        self.title = title
        self.value = value
        self.regex = regex
    }
}
