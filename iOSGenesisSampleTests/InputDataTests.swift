//
//  InputDataTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import iOSGenesisSample
@testable import GenesisSwift

class InputDataTests: XCTestCase {
    
    var sut: InputDataObject!
    var data = InputData()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperties() {
        sut = InputDataObject(title: "fixed.title", value: "fixed.value")
        XCTAssertEqual(sut.title, "fixed.title")
        XCTAssertEqual(sut.value, "fixed.value")
    }
    
    func testInputData(data: [DataProtocol]) {
        let customerEmail = data[4]
        
        XCTAssertEqual(customerEmail.title, "Customer Email")
        XCTAssertEqual(customerEmail.value, "john.doe@example.com")
        
        let country = data[13] as? PickerData
        
        XCTAssertTrue(country != nil)
        
        XCTAssertEqual(country?.title, "Country")
        XCTAssertEqual(country?.value, "United States")
        
        XCTAssertTrue(country!.items.count > 0)
    }
    
    func testDefaultInputData() {
        let inputDataDefault = data.allObjects

        self.testInputData(data: inputDataDefault as! [DataProtocol])
    }
    
    func testConverts() {
        let inputDataDefault = data.allObjects
        
        let inputArray = data.convertInputDataToArray(inputArray: inputDataDefault as! Array<DataProtocol>)
        
        XCTAssertTrue(inputArray.count > 0)
        
        let inputData = data.convertArrayToInputData(inputArray: inputArray)
        
        self.testInputData(data: inputData)
    }
    
    func testSave() {
        data.address1.value = "New.fixed.address1"
        data.save()
        
        let newData = InputData()
        XCTAssertEqual(newData.address1.value, "New.fixed.address1")
        
        newData.address1.value = "23, Doestreet"
        newData.save()
    }
}
