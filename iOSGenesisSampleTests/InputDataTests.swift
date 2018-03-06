//
//  InputDataTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import iOSGenesisSample

class InputDataTests: XCTestCase {
    
    var sut: InputData!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperties() {
        sut = InputData(title: "fixed.title", value: "fixed.value")
        XCTAssertEqual(sut.title, "fixed.title")
        XCTAssertEqual(sut.value, "fixed.value")
    }
}
