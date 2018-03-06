//
//  InputDataTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import iOSGenesisSample
@testable import GenesisSwift

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
    
    func testInputData(data: [DataProtocol]) {
        let customerEmail = data[3]
        
        XCTAssertEqual(customerEmail.title, "Customer Email")
        XCTAssertEqual(customerEmail.value, "john.doe@example.com")
        
        let country = data[12] as? PickerData
        
        XCTAssertTrue(country != nil)
        
        XCTAssertEqual(country?.title, "Country")
        XCTAssertEqual(country?.value, "United States")
        
        XCTAssertTrue(country!.items.count > 0)
    }
    
    func testDefaultInputData() {
        let inputDataDefault = InputDataHelper.inputDataDefault

        self.testInputData(data: inputDataDefault)
    }
    
    func testConverts() {
        let inputDataDefault = InputDataHelper.inputDataDefault
        
        let inputArray = InputDataHelper.convertInputDataToArray(inputArray: inputDataDefault)
        
        XCTAssertTrue(inputArray.count > 0)
        
        let inputData = InputDataHelper.convertArrayToInputData(inputArray: inputArray)
        
        self.testInputData(data: inputData)
    }
}
