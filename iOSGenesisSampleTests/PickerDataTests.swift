//
//  PickerDataTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import iOSGenesisSample

class PickerDataTests: XCTestCase {
    
    var sut: PickerData!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperties() {
        sut = PickerData(title: "fixed.title", value: "fixed.value", items: [])
        XCTAssertEqual(sut.title, "fixed.title")
        XCTAssertEqual(sut.value, "fixed.value")
    }
}
