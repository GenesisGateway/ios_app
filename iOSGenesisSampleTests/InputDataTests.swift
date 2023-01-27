//
//  InputDataTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import iOSGenesisSample
@testable import GenesisSwift

final class InputDataTests: XCTestCase {
}

extension InputDataTests {

    func testProperties() {
        let sut = InputDataObject(title: "fixed.title", value: "fixed.value")
        XCTAssertEqual(sut.title, "fixed.title")
        XCTAssertEqual(sut.value, "fixed.value")
    }
    
    func testDefaultInputData() {
        let data = InputData(transactionName: .sale)
        verifyInputData(data: data.objects)
    }
    
    func testConverts() {
        let data = InputData(transactionName: .sale)
        let inputDataDefault = data.objects
        
        let inputArray = data.convertInputDataToArray(inputArray: inputDataDefault)
        
        XCTAssertTrue(inputArray.count > 0)
        
        let inputData = data.inputData(from: inputArray)
        
        verifyInputData(data: inputData)
    }
    
    func testSave() {
        let data = InputData(transactionName: .sale)
        data.address1.value = "New.fixed.address1"
        data.save()
        
        let newData = InputData(transactionName: .sale)
        XCTAssertEqual(newData.address1.value, "New.fixed.address1")
        
        newData.address1.value = "23, Doestreet"
        newData.save()
    }

    func test3DSData() {
        let saleData = InputData(transactionName: .sale)
        XCTAssertFalse(saleData.requires3DS)
        let salePaymentRequest = saleData.createPaymentRequest()
        XCTAssertFalse(salePaymentRequest.requires3DS)
        XCTAssertNil(salePaymentRequest.threeDSV2Params)
        XCTAssertFalse(saleData.objects.contains(where: { $0 === saleData.challengeIndicator }))

        let sale3DSData = InputData(transactionName: .sale3d)
        XCTAssertTrue(sale3DSData.requires3DS)
        let sale3DSPaymentRequest = sale3DSData.createPaymentRequest()
        XCTAssertTrue(sale3DSPaymentRequest.requires3DS)
        XCTAssertNotNil(sale3DSPaymentRequest.threeDSV2Params)
        XCTAssertTrue(sale3DSData.objects.contains(where: { $0 === sale3DSData.challengeIndicator }))
    }

    func testManagedRecurring() {

        var data = InputData(transactionName: .sale)
        XCTAssertFalse(data.supportsManagedRecurring)
        var request = data.createPaymentRequest()
        request.transactionTypes.forEach { XCTAssertNil($0.managedRecurring) }

        data = InputData(transactionName: .initRecurringSale)
        XCTAssertTrue(data.supportsManagedRecurring)
        request = data.createPaymentRequest()
        request.transactionTypes.forEach { XCTAssertNil($0.managedRecurring) }

        data.managedRecurringMode.value = InputData.ManagedRecurringMode.automatic.rawValue

        request = data.createPaymentRequest()
        request.transactionTypes.forEach { XCTAssertNotNil($0.managedRecurring) }

        data.managedRecurringMode.value = InputData.ManagedRecurringMode.notAvailable.rawValue
        request = data.createPaymentRequest()
        request.transactionTypes.forEach { XCTAssertNil($0.managedRecurring) }

        data.managedRecurringMode.value = InputData.ManagedRecurringMode.manual.rawValue
        request = data.createPaymentRequest()
        request.transactionTypes.forEach { XCTAssertNotNil($0.managedRecurring) }
    }

    func testRecurringTypes() {

        var data = InputData(transactionName: .sale)
        XCTAssertTrue(data.supportsRecurringType)
        var request = data.createPaymentRequest()
        XCTAssertNotNil(request.recurringType)

        data = InputData(transactionName: .sale3d)
        XCTAssertTrue(data.supportsRecurringType)
        request = data.createPaymentRequest()
        XCTAssertNotNil(request.recurringType)

        data = InputData(transactionName: .authorize)
        XCTAssertTrue(data.supportsRecurringType)
        request = data.createPaymentRequest()
        XCTAssertNotNil(request.recurringType)

        data = InputData(transactionName: .authorize3d)
        XCTAssertTrue(data.supportsRecurringType)
        request = data.createPaymentRequest()
        XCTAssertNotNil(request.recurringType)

        data = InputData(transactionName: .initRecurringSale)
        XCTAssertFalse(data.supportsRecurringType)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringType)

        data = InputData(transactionName: .initRecurringSale3d)
        XCTAssertFalse(data.supportsRecurringType)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringType)

        data = InputData(transactionName: .paysafecard)
        XCTAssertFalse(data.supportsRecurringType)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringType)
    }

    func testRecurringCategory() {

        var data = InputData(transactionName: .initRecurringSale)
        XCTAssertTrue(data.supportsRecurringCategory)
        var request = data.createPaymentRequest()
        XCTAssertNotNil(request.recurringCategory)

        data = InputData(transactionName: .initRecurringSale3d)
        XCTAssertTrue(data.supportsRecurringCategory)
        request = data.createPaymentRequest()
        XCTAssertNotNil(request.recurringCategory)

        data = InputData(transactionName: .sale)
        XCTAssertFalse(data.supportsRecurringCategory)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringCategory)

        data = InputData(transactionName: .sale3d)
        XCTAssertFalse(data.supportsRecurringCategory)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringCategory)

        data = InputData(transactionName: .authorize)
        XCTAssertFalse(data.supportsRecurringCategory)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringCategory)

        data = InputData(transactionName: .authorize3d)
        XCTAssertFalse(data.supportsRecurringCategory)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringCategory)

        data = InputData(transactionName: .paysafecard)
        XCTAssertFalse(data.supportsRecurringCategory)
        request = data.createPaymentRequest()
        XCTAssertNil(request.recurringCategory)
    }
}

private extension InputDataTests {

    func verifyInputData(data: [GenesisSwift.DataProtocol]) {
        let customerEmail = data[4]

        XCTAssertEqual(customerEmail.title, "Customer Email")
        XCTAssertEqual(customerEmail.value, "john.doe@example.com")

        let country = data[13] as? PickerData

        XCTAssertTrue(country != nil)

        XCTAssertEqual(country?.title, "Country")
        XCTAssertEqual(country?.value, "United States")

        XCTAssertTrue(country!.items.count > 0)
    }
}
