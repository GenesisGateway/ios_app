//
//  ObjectData.swift
//  iOSGenesisSample
//
//  Created by Ivaylo Hadzhiev on 26.01.23.
//

import Foundation
import GenesisSwift

protocol ObjectDataProtocol: AnyObject, GenesisSwift.DataProtocol {}

public class InputDataObject: ObjectDataProtocol {
    public var title: String
    public var value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
