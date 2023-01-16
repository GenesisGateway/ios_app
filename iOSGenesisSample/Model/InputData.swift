//
//  InputData.swift
//  iOSGenesisSample
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

public final class InputData: NSObject {

    private let transactionName: TransactionName

    private(set) lazy var transactionId = InputDataObject(title: Titles.transactionId.rawValue, value: "wev238f328nc" + String(arc4random_uniform(999999)))
    private(set) lazy var amount = ValidatedInputData(title: Titles.amount.rawValue, value: "1234.56", regex: Regex.amount)
    private(set) lazy var currency = PickerData(title: Titles.currency.rawValue, value: "USD", items: Currencies().allCurrencies)
    private(set) lazy var usage = InputDataObject(title: Titles.usage.rawValue, value: "Tickets")
    private(set) lazy var customerEmail = ValidatedInputData(title: Titles.customerEmail.rawValue, value: "john.doe@example.com", regex: Regex.email)
    private(set) lazy var customerPhone = InputDataObject(title: Titles.customerPhone.rawValue, value: "+11234567890")
    private(set) lazy var firstName = InputDataObject(title: Titles.firstName.rawValue, value: "John")
    private(set) lazy var lastName = InputDataObject(title: Titles.lastName.rawValue, value: "Doe")
    private(set) lazy var address1 = InputDataObject(title: Titles.address1.rawValue, value: "23, Doestreet")
    private(set) lazy var address2 = InputDataObject(title: Titles.address2.rawValue, value: "")
    private(set) lazy var zipCode = InputDataObject(title: Titles.zipCode.rawValue, value: "11923")
    private(set) lazy var city = InputDataObject(title: Titles.city.rawValue, value: "New York City")
    private(set) lazy var state =  InputDataObject(title: Titles.state.rawValue, value: "NY")
    private(set) lazy var country = PickerData(title: Titles.country.rawValue, value: "United States", items: IsoCountries.allCountries)
    private(set) lazy var notificationUrl = InputDataObject(title: Titles.notificationUrl.rawValue, value: "https://example.com/notification")

    // managed recurring
    private(set) lazy var managedRecurringMode = PickerData(title: Titles.recurringMode.rawValue,
                                                            value: ManagedRecurringMode.notAvailable.rawValue,
                                                            items: ManagedRecurringMode.allCases
                                                                .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var recurringMaxCount = ValidatedInputData(title: Titles.recurringMaxCount.rawValue,
                                                                 value: "10",
                                                                 regex: Regex.integer)
    // automatic managed recurring
    private(set) lazy var recurringPeriod = ValidatedInputData(title: Titles.autoRecurringPeriod.rawValue,
                                                               value: "22",
                                                               regex: Regex.integer)
    private(set) lazy var recurringInterval = PickerData(title: Titles.autoRecurringInterval.rawValue,
                                                         value: ManagedRecurringParams.Automatic.IntervalValues.days.rawValue,
                                                         items: ManagedRecurringParams.Automatic.IntervalValues.allCases
                                                             .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var recurringFirstDate = ValidatedInputData(title: Titles.autoRecurringFirstDate.rawValue,
                                                                  value: Date().dateByAdding(6, to: .month)!.iso8601Date,
                                                                  regex: Regex.date)
    private(set) lazy var recurringTimeOfDay = ValidatedInputData(title: Titles.autoRecurringTimeOfDay.rawValue,
                                                                  value: "5",
                                                                  regex: Regex.integer)
    private(set) lazy var recurringAmount = ValidatedInputData(title: Titles.autoRecurringAmount.rawValue,
                                                               value: "500",
                                                               regex: Regex.integer)
    // manual managed recurring
    private(set) lazy var recurringPaymentType = PickerData(title: Titles.manualRecurringPaymentType.rawValue,
                                                            value: ManagedRecurringParams.Manual.PaymentTypeValues.subsequent.rawValue,
                                                            items: ManagedRecurringParams.Manual.PaymentTypeValues.allCases
                                                                .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var recurringAmountType = PickerData(title: Titles.manualRecurringAmountType.rawValue,
                                                           value: ManagedRecurringParams.Manual.AmountTypeValues.fixed.rawValue,
                                                           items: ManagedRecurringParams.Manual.AmountTypeValues.allCases
                                                               .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var recurringFrequency = PickerData(title: Titles.manualRecurringFrequency.rawValue,
                                                          value: ManagedRecurringParams.Manual.FrequencyValues.weekly.rawValue,
                                                          items: ManagedRecurringParams.Manual.FrequencyValues.allCases
                                                              .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var recurringRegistrationReferenceNumber =
        InputDataObject(title: Titles.manualRecurringRegistrationReferenceNumber.rawValue, value: "123434")
    private(set) lazy var recurringMaxAmount = ValidatedInputData(title: Titles.manualRecurringMaxAmount.rawValue,
                                                                  value: "200",
                                                                  regex: Regex.integer)
    private(set) lazy var recurringValidated = PickerData(title: Titles.manualRecurringValidated.rawValue,
                                                          value: BooleanChoice.yes.rawValue,
                                                          items: BooleanChoice.allCases
                                                                   .map { EnumPickerItem($0.rawValue) })

    // 3DSv2 parameters

    // control
    private(set) lazy var challengeIndicator =
        PickerData(title: Titles.challengeIndicator.rawValue,
                   value: ThreeDSV2Params.ControlParams.ChallengeIndicatorValues.noPreference.rawValue,
                   items: ThreeDSV2Params.ControlParams.ChallengeIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var challengeWindowSize =
        PickerData(title: Titles.challengeWindowSize.rawValue,
                   value: ThreeDSV2Params.ControlParams.ChallengeWindowSizeValues.fullScreen.rawValue,
                   items: ThreeDSV2Params.ControlParams.ChallengeWindowSizeValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    // purchase
    private(set) lazy var category =
        PickerData(title: Titles.category.rawValue,
                   value: ThreeDSV2Params.PurchaseParams.CategoryValues.goods.rawValue,
                   items: ThreeDSV2Params.PurchaseParams.CategoryValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    // recurring
    private(set) lazy var expirationDate = ValidatedInputData(title: Titles.expirationDate.rawValue,
                                                              value: Date().dateByAdding(6, to: .month)!.iso8601Date,
                                                              regex: Regex.date)
    private(set) lazy var frequency = ValidatedInputData(title: Titles.frequency.rawValue,
                                                         value: "30",
                                                         regex: Regex.integer)
    // merchant risk
    private(set) lazy var shippingIndicator =
        PickerData(title: Titles.shippingIndicator.rawValue,
                   value: ThreeDSV2Params.MerchantRiskParams.ShippingIndicatorValues.sameAsBilling.rawValue,
                   items: ThreeDSV2Params.MerchantRiskParams.ShippingIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var deliveryTimeframe =
        PickerData(title: Titles.deliveryTimeframe.rawValue,
                   value: ThreeDSV2Params.MerchantRiskParams.DeliveryTimeframeValues.electronic.rawValue,
                   items: ThreeDSV2Params.MerchantRiskParams.DeliveryTimeframeValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var reorderItemsIndicator =
        PickerData(title: Titles.reorderItemsIndicator.rawValue,
                   value: ThreeDSV2Params.MerchantRiskParams.ReorderItemsIndicatorValues.firstTime.rawValue,
                   items: ThreeDSV2Params.MerchantRiskParams.ReorderItemsIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var preOrderPurchaseIndicator =
        PickerData(title: Titles.preOrderPurchaseIndicator.rawValue,
                   value: ThreeDSV2Params.MerchantRiskParams.PreOrderPurchaseIndicatorValues.merchandiseAvailable.rawValue,
               items: ThreeDSV2Params.MerchantRiskParams.PreOrderPurchaseIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var preOrderDate = ValidatedInputData(title: Titles.preOrderDate.rawValue,
                                                            value: Date().iso8601Date,
                                                            regex: Regex.date)
    private(set) lazy var giftCard = PickerData(title: Titles.giftCard.rawValue,
                                                value: BooleanChoice.yes.rawValue,
                                                items: BooleanChoice.allCases
                                                         .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var giftCardCount = ValidatedInputData(title: Titles.giftCardCount.rawValue,
                                                             value: "2",
                                                             regex: Regex.integer)

    // card holder account
    private(set) lazy var creationDate = ValidatedInputData(title: Titles.creationDate.rawValue,
                                                            value: Date().iso8601Date,
                                                            regex: Regex.date)
    private(set) lazy var updateIndicator =
        PickerData(title: Titles.updateIndicator.rawValue,
                   value: ThreeDSV2Params.CardHolderAccountParams.UpdateIndicatorValues.currentTransaction.rawValue,
                   items: ThreeDSV2Params.CardHolderAccountParams.UpdateIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var lastChangeDate = ValidatedInputData(title: Titles.lastChangeDate.rawValue,
                                                              value: Date().dateBySubstracting(3, from: .month)!.iso8601Date,
                                                              regex: Regex.date)
    private(set) lazy var passwordChangeIndicator =
        PickerData(title: Titles.passwordChangeIndicator.rawValue,
                   value: ThreeDSV2Params.CardHolderAccountParams.PasswordChangeIndicatorValues.noChange.rawValue,
                   items: ThreeDSV2Params.CardHolderAccountParams.PasswordChangeIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var passwordChangeDate = ValidatedInputData(title: Titles.passwordChangeDate.rawValue,
                                                                  value: Date().dateBySubstracting(15, from: .day)!.iso8601Date,
                                                                  regex: Regex.date)
    private(set) lazy var shippingAddressUsageIndicator =
        PickerData(title: Titles.shippingAddressUsageIndicator.rawValue,
                   value: ThreeDSV2Params.CardHolderAccountParams.ShippingAddressUsageIndicatorValues.currentTransaction.rawValue,
                   items: ThreeDSV2Params.CardHolderAccountParams.ShippingAddressUsageIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var shippingAddressDateFirstUsed = ValidatedInputData(title: Titles.shippingAddressDateFirstUsed.rawValue,
                                                                            value: Date().dateBySubstracting(5, from: .day)!.iso8601Date,
                                                                            regex: Regex.date)
    private(set) lazy var transactionsActivityLast24Hours = ValidatedInputData(title: Titles.transactionsActivityLast24Hours.rawValue,
                                                                               value: "2",
                                                                               regex: Regex.integer)
    private(set) lazy var transactionsActivityPreviousYear = ValidatedInputData(title: Titles.transactionsActivityPreviousYear.rawValue,
                                                                                value: "10",
                                                                                regex: Regex.integer)
    private(set) lazy var provisionAttemptsLast24Hours = ValidatedInputData(title: Titles.provisionAttemptsLast24Hours.rawValue,
                                                                            value: "1",
                                                                            regex: Regex.integer)
    private(set) lazy var purchasesCountLast6Months = ValidatedInputData(title: Titles.purchasesCountLast6Months.rawValue,
                                                                         value: "5",
                                                                         regex: Regex.integer)
    private(set) lazy var suspiciousActivityIndicator =
        PickerData(title: Titles.suspiciousActivityIndicator.rawValue,
                   value: ThreeDSV2Params.CardHolderAccountParams.SuspiciousActivityIndicatorValues.noSuspiciousObserved.rawValue,
                   items: ThreeDSV2Params.CardHolderAccountParams.SuspiciousActivityIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var registrationIndicator =
        PickerData(title: Titles.registrationIndicator.rawValue,
                   value: ThreeDSV2Params.CardHolderAccountParams.RegistrationIndicatorValues.currentTransaction.rawValue,
                   items: ThreeDSV2Params.CardHolderAccountParams.SuspiciousActivityIndicatorValues.allCases
                            .map { EnumPickerItem($0.rawValue) })
    private(set) lazy var registrationDate = ValidatedInputData(title: Titles.registrationDate.rawValue,
                                                                value: Date().dateBySubstracting(2, from: .year)!.iso8601Date,
                                                                regex: Regex.date)

    private var defaultObjects: [ObjectDataProtocol] {
        var all: [ObjectDataProtocol] = [transactionId, amount, currency, usage, customerEmail, customerPhone,
                                         firstName, lastName, address1, address2, zipCode, city, state, country, notificationUrl]
        if supportsManagedRecurring {
            all.append(managedRecurringMode)
            switch ManagedRecurringMode(rawValue: managedRecurringMode.value) {
            case .automatic:
                all.append(contentsOf: automaticManagedOcurringObjects)
            case .manual:
                all.append(contentsOf: manualManagedOcurringObjects)
            default:
                break
            }
        }
        return all
    }

    private var automaticManagedOcurringObjects: [ObjectDataProtocol] {
        [recurringInterval, recurringFirstDate, recurringTimeOfDay, recurringPeriod, recurringAmount, recurringMaxCount]
    }

    private var manualManagedOcurringObjects: [ObjectDataProtocol] {
        [recurringPaymentType, recurringAmountType, recurringFrequency, recurringRegistrationReferenceNumber,
         recurringMaxAmount, recurringMaxCount, recurringValidated]
    }

    private var allObjects: [ObjectDataProtocol] {
        var all = [ObjectDataProtocol]()
        all.append(contentsOf: defaultObjects)
        let threeDSParams: [ObjectDataProtocol] = [challengeIndicator, challengeWindowSize,
            category,
            expirationDate, frequency,
            shippingIndicator, deliveryTimeframe, reorderItemsIndicator, preOrderPurchaseIndicator, preOrderDate, giftCard, giftCardCount,
            creationDate, updateIndicator, lastChangeDate, passwordChangeIndicator, passwordChangeDate, shippingAddressUsageIndicator,
            shippingAddressDateFirstUsed, transactionsActivityLast24Hours, transactionsActivityPreviousYear, provisionAttemptsLast24Hours,
            purchasesCountLast6Months, suspiciousActivityIndicator, registrationIndicator, registrationDate]
        all.append(contentsOf: threeDSParams)
        return all
    }

    var supportsManagedRecurring: Bool {
        switch transactionName {
        case .initRecurringSale, .initRecurringSale3d:
            return true
        default:
            return false
        }
    }

    var requires3DS: Bool {
        switch transactionName {
        case .authorize3d, .sale3d, .initRecurringSale3d:
            return true
        default:
            return false
        }
    }

    var objects: [ObjectDataProtocol] {
        requires3DS ? allObjects : defaultObjects
    }

    init(transactionName: TransactionName) {
        self.transactionName = transactionName
        super.init()
        loadInputData()
    }
    
    func save() {
        let data = convertInputDataToArray(inputArray: allObjects)
        UserDefaults.standard.set(data, forKey: StorageKeys.commonData)
    }
}

extension InputData {

    enum Titles: String {
        case transactionId = "Transaction Id"
        case amount = "Amount"
        case currency = "Currency"
        case usage = "Usage"
        case customerEmail = "Customer Email"
        case customerPhone = "Customer Phone"
        case firstName = "First Name"
        case lastName = "Last Name"
        case address1 = "Address 1"
        case address2 = "Address 2"
        case zipCode = "ZIP Code"
        case city = "City"
        case state = "State"
        case country = "Country"
        case notificationUrl = "Notification URL"

        // Managed Recurring
        case recurringMode = "Managed Recurring Mode"
        case recurringMaxCount = "Recurring Max Count"

        case autoRecurringPeriod = "Recurring Period"
        case autoRecurringInterval = "Recurring Interval"
        case autoRecurringFirstDate = "Recurring First Date"
        case autoRecurringTimeOfDay = "Recurring Time of Day"
        case autoRecurringAmount = "Recurring Amount"

        case manualRecurringPaymentType = "Recurring Payment Type"
        case manualRecurringAmountType = "Recurring Amount Type"
        case manualRecurringFrequency = "Recurring Frequency"
        case manualRecurringRegistrationReferenceNumber = "Recurring Registration Reference Number"
        case manualRecurringMaxAmount = "Recurring Max Amount"
        case manualRecurringValidated = "Recurring Validated"

        // 3DSv2 parameters
        case challengeIndicator = "Challenge Indicator"
        case challengeWindowSize = "Challenge Window Size"
        case category = "Category"
        case expirationDate = "Expiration Date"
        case frequency = "Frequency"
        case shippingIndicator = "Shipping Indicator"
        case deliveryTimeframe = "Delivery Timeframe"
        case reorderItemsIndicator = "Reorder Items Indicator"
        case preOrderPurchaseIndicator = "PreOrder Purchase Indicator"
        case preOrderDate = "PreOrder Date"
        case giftCard = "Gift Card"
        case giftCardCount = "Gift Card Count"
        case creationDate = "Creation Date"
        case updateIndicator = "Update Indicator"
        case lastChangeDate = "Last Change Date"
        case passwordChangeIndicator = "Password Change Indicator"
        case passwordChangeDate = "Password Change Date"
        case shippingAddressUsageIndicator = "Shipping Address Usage Indicator"
        case shippingAddressDateFirstUsed = "Shipping Address Date First Used"
        case transactionsActivityLast24Hours = "Transactions Activity Last 24 Hours"
        case transactionsActivityPreviousYear = "Transactions Activity Previous Year"
        case provisionAttemptsLast24Hours = "Provision Attempts Last 24 Hours"
        case purchasesCountLast6Months = "Purchases Count Last 6 Months"
        case suspiciousActivityIndicator = "Suspicious Activity Indicator"
        case registrationIndicator = "Registration Indicator"
        case registrationDate = "Registration Date"
    }

    enum ManagedRecurringMode: String, CaseIterable {
        case notAvailable = "N/A"
        case automatic
        case manual
    }
}

private extension InputData {

    enum StorageTypes: String {
        case dataObject = "InputDataObject"
        case pickerData = "PickerData"
        case validatedData = "ValidatedInputData"
    }
    enum StorageKeys {
        static let commonData = "UserDefaultsDataKey"
    }

    enum Regex {
        static let amount = "^?\\d*(\\.\\d{0,3})?$"
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let date = "^(0[1-9]|[12][0-9]|3[01])\\-(0[1-9]|1[012])\\-\\d{4}$"
        static let integer = "^\\d+$"
        static let boolean = "^(yes|no)$"
    }

    enum BooleanChoice: String, CaseIterable {
        case yes
        case no
    }
}

// MARK: - PaymentRequest creation

extension InputData {

    var paymentAddress: PaymentAddress {
        PaymentAddress(firstName: firstName.value,
                       lastName: lastName.value,
                       address1: address1.value,
                       address2: address2.value,
                       zipCode: zipCode.value,
                       city: city.value,
                       state: state.value,
                       country: IsoCountryCodes.search(byName: country.value))
    }

    var managedRecurringParams: ManagedRecurringParams? {
        guard supportsManagedRecurring else { return nil }
        switch ManagedRecurringMode(rawValue: managedRecurringMode.value) {
        case .automatic:
            let period = Int(recurringPeriod.value)!
            let interval = ManagedRecurringParams.Automatic.IntervalValues(rawValue: recurringInterval.value)!
            let firstDate = recurringFirstDate.value.dateFromISO8601Date
            let timeOfDay = Int(recurringTimeOfDay.value)!
            let amount = Int(recurringAmount.value)
            let maxCount = Int(recurringMaxCount.value)
            let automaticManagedRecurrring =
                ManagedRecurringParams.Automatic(period: period, interval: interval, firstDate: firstDate,
                                                 timeOfDay: timeOfDay, amount: amount, maxCount: maxCount)
            return ManagedRecurringParams(mode: .automatic(automaticManagedRecurrring))
        case .manual:
            let paymentType = ManagedRecurringParams.Manual.PaymentTypeValues(rawValue: recurringPaymentType.value)!
            let amountType = ManagedRecurringParams.Manual.AmountTypeValues(rawValue: recurringAmountType.value)!
            let frequency = ManagedRecurringParams.Manual.FrequencyValues(rawValue: recurringFrequency.value)!
            let refNumber = recurringRegistrationReferenceNumber.value
            let maxAmount = Int(recurringMaxAmount.value)!
            let maxCount = Int(recurringMaxCount.value)!
            let validated = recurringValidated.value.lowercased() == BooleanChoice.yes.rawValue
            let manualManagedRecurrring =
                ManagedRecurringParams.Manual(paymentType: paymentType, amountType: amountType, frequency: frequency,
                                              registrationReferenceNumber: refNumber, maxAmount: maxAmount,
                                              maxCount: maxCount, validated: validated)
            return ManagedRecurringParams(mode: .manual(manualManagedRecurrring))
        default:
            return nil
        }
    }

    var threeDSParams: ThreeDSV2Params {
        var threeDSV2Params = ThreeDSV2Params()

        typealias CP = ThreeDSV2Params.ControlParams
        threeDSV2Params.controlParams.challengeIndicator = CP.ChallengeIndicatorValues(rawValue: challengeIndicator.value)!
        threeDSV2Params.controlParams.challengeWindowSize = CP.ChallengeWindowSizeValues(rawValue: challengeWindowSize.value)

        typealias PP = ThreeDSV2Params.PurchaseParams
        threeDSV2Params.purchaseParams = PP(category: ThreeDSV2Params.PurchaseParams.CategoryValues(rawValue: category.value))

        typealias RP = ThreeDSV2Params.RecurringParams
        threeDSV2Params.recurringParams = RP(expirationDate: expirationDate.value.dateFromISO8601Date,
                                             frequency: Int(frequency.value))

        typealias MRP = ThreeDSV2Params.MerchantRiskParams
        threeDSV2Params.merchantRiskParams =
            MRP(shippingIndicator: MRP.ShippingIndicatorValues(rawValue: shippingIndicator.value),
                deliveryTimeframe: MRP.DeliveryTimeframeValues(rawValue: deliveryTimeframe.value),
                reorderItemsIndicator: MRP.ReorderItemsIndicatorValues(rawValue: reorderItemsIndicator.value),
                preOrderPurchaseIndicator: MRP.PreOrderPurchaseIndicatorValues(rawValue: preOrderPurchaseIndicator.value),
                preOrderDate: preOrderDate.value.dateFromISO8601Date,
                giftCard: giftCard.value.lowercased() == BooleanChoice.yes.rawValue,
                giftCardCount: Int(giftCardCount.value))

        typealias CHAP = ThreeDSV2Params.CardHolderAccountParams
        threeDSV2Params.cardHolderAccountParams =
            CHAP(creationDate: creationDate.value.dateFromISO8601Date,
                 updateIndicator: CHAP.UpdateIndicatorValues(rawValue: updateIndicator.value),
                 lastChangeDate: lastChangeDate.value.dateFromISO8601Date,
                 passwordChangeIndicator: CHAP.PasswordChangeIndicatorValues(rawValue: passwordChangeIndicator.value),
                 passwordChangeDate: passwordChangeDate.value.dateFromISO8601Date,
                 shippingAddressUsageIndicator: CHAP.ShippingAddressUsageIndicatorValues(rawValue: shippingAddressUsageIndicator.value),
                 shippingAddressDateFirstUsed: shippingAddressDateFirstUsed.value.dateFromISO8601Date,
                 transactionsActivityLast24Hours: Int(transactionsActivityLast24Hours.value),
                 transactionsActivityPreviousYear: Int(transactionsActivityPreviousYear.value),
                 provisionAttemptsLast24Hours: Int(provisionAttemptsLast24Hours.value),
                 purchasesCountLast6Months: Int(purchasesCountLast6Months.value),
                 suspiciousActivityIndicator: CHAP.SuspiciousActivityIndicatorValues(rawValue: suspiciousActivityIndicator.value),
                 registrationIndicator: CHAP.RegistrationIndicatorValues(rawValue: registrationIndicator.value),
                 registrationDate: registrationDate.value.dateFromISO8601Date)

        return threeDSV2Params
    }

    func createPaymentRequest() -> PaymentRequest {

        let paymentTransactionType = PaymentTransactionType(name: transactionName)
        paymentTransactionType.managedRecurring = managedRecurringParams

        let paymentRequest = PaymentRequest(transactionId: transactionId.value,
                                               amount: amount.value.explicitConvertionToDecimal()!,
                                               currency: Currencies.findCurrencyInfoByName(name: currency.value)!,
                                               customerEmail: customerEmail.value,
                                               customerPhone: customerPhone.value,
                                               billingAddress: paymentAddress,
                                               transactionTypes: [paymentTransactionType],
                                               notificationUrl: notificationUrl.value)
        paymentRequest.usage = usage.value

        if paymentRequest.requires3DS {
            paymentRequest.threeDSV2Params = threeDSParams
        }

        return paymentRequest
    }
}

extension InputData {

    func loadInputData() {
        guard let storedData = UserDefaults.standard.array(forKey: StorageKeys.commonData) as? [[String: String]] else {
            save()
            return
        }

        let loadedInputDataSource = inputData(from: storedData)
        for inputData in loadedInputDataSource {
            guard let titles = Titles(rawValue: inputData.title) else {
                assertionFailure("Unknown title: \(inputData.title)")
                continue
            }
            switch titles {
            case .transactionId: continue
            case .amount: amount = inputData as! ValidatedInputData
            case .currency: currency = inputData as! PickerData
            case .usage: usage = inputData as! InputDataObject
            case .customerEmail: customerEmail = inputData as! ValidatedInputData
            case .customerPhone: customerPhone = inputData as! InputDataObject
            case .firstName: firstName = inputData as! InputDataObject
            case .lastName: lastName = inputData as! InputDataObject
            case .address1: address1 = inputData as! InputDataObject
            case .address2: address2 = inputData as! InputDataObject
            case .zipCode: zipCode = inputData as! InputDataObject
            case .city: city = inputData as! InputDataObject
            case .state: state = inputData as! InputDataObject
            case .country: country = inputData as! PickerData
            case .notificationUrl: notificationUrl = inputData as! InputDataObject

            // managed recurring parameters
            case .recurringMode: managedRecurringMode = inputData as! PickerData
            case .recurringMaxCount: recurringMaxCount = inputData as! ValidatedInputData
            case .autoRecurringPeriod: recurringPeriod = inputData as! ValidatedInputData
            case .autoRecurringInterval: recurringInterval = inputData as! PickerData
            case .autoRecurringFirstDate: recurringFirstDate = inputData as! ValidatedInputData
            case .autoRecurringTimeOfDay: recurringTimeOfDay = inputData as! ValidatedInputData
            case .autoRecurringAmount: recurringAmount = inputData as! ValidatedInputData
            case .manualRecurringPaymentType: recurringPaymentType = inputData as! PickerData
            case .manualRecurringAmountType: recurringAmountType = inputData as! PickerData
            case .manualRecurringFrequency: recurringFrequency = inputData as! PickerData
            case .manualRecurringRegistrationReferenceNumber: recurringRegistrationReferenceNumber = inputData as! InputDataObject
            case .manualRecurringMaxAmount: recurringMaxAmount = inputData as! ValidatedInputData
            case .manualRecurringValidated: recurringValidated = inputData as! PickerData

            // 3DSv2 parameters
            case .challengeIndicator: challengeIndicator = inputData as! PickerData
            case .challengeWindowSize: challengeWindowSize = inputData as! PickerData

            case .category: category = inputData as! PickerData

            case .expirationDate: expirationDate = inputData as! ValidatedInputData
            case .frequency: frequency = inputData as! ValidatedInputData

            case .shippingIndicator: shippingIndicator = inputData as! PickerData
            case .deliveryTimeframe: deliveryTimeframe = inputData as! PickerData
            case .reorderItemsIndicator: reorderItemsIndicator = inputData as! PickerData
            case .preOrderPurchaseIndicator: preOrderPurchaseIndicator = inputData as! PickerData
            case .preOrderDate: preOrderDate = inputData as! ValidatedInputData
            case .giftCard: giftCard = inputData as! PickerData
            case .giftCardCount: giftCardCount = inputData as! ValidatedInputData

            case .creationDate: creationDate = inputData as! ValidatedInputData
            case .updateIndicator: updateIndicator = inputData as! PickerData
            case .lastChangeDate: lastChangeDate = inputData as! ValidatedInputData
            case .passwordChangeIndicator: passwordChangeIndicator = inputData as! PickerData
            case .passwordChangeDate: passwordChangeDate = inputData as! ValidatedInputData
            case .shippingAddressUsageIndicator: shippingAddressUsageIndicator = inputData as! PickerData
            case .shippingAddressDateFirstUsed: shippingAddressDateFirstUsed = inputData as! ValidatedInputData
            case .transactionsActivityLast24Hours: transactionsActivityLast24Hours = inputData as! ValidatedInputData
            case .transactionsActivityPreviousYear: transactionsActivityPreviousYear = inputData as! ValidatedInputData
            case .provisionAttemptsLast24Hours: provisionAttemptsLast24Hours = inputData as! ValidatedInputData
            case .purchasesCountLast6Months: purchasesCountLast6Months = inputData as! ValidatedInputData
            case .suspiciousActivityIndicator: suspiciousActivityIndicator = inputData as! PickerData
            case .registrationIndicator: registrationIndicator = inputData as! PickerData
            case .registrationDate: registrationDate = inputData as! ValidatedInputData
            }
        }
    }

    func convertInputDataToArray(inputArray: [GenesisSwift.DataProtocol]) -> [[String: String]] {
        var array = [[String: String]]()
        for data in inputArray {
            var dictionary = [String: String]()
            dictionary["title"] = data.title
            dictionary["value"] = data.value
            dictionary["regex"] = data.regex
            dictionary["type"] = String(describing: type(of: data))
            array.append(dictionary)
        }
        return array
    }
    
    func inputData(from inputArray: [[String: String]]) -> [GenesisSwift.DataProtocol] {
        var array = [GenesisSwift.DataProtocol]()
        for dictionary in inputArray {
            if let title = dictionary["title"],
                let value = dictionary["value"],
                let regex = dictionary["regex"],
                let rawType = dictionary["type"], let type = StorageTypes(rawValue: rawType) {

                switch type {
                case .dataObject:
                    array.append(InputDataObject(title: title, value: value))
                case .validatedData:
                    array.append(ValidatedInputData(title: title, value: value, regex: regex))
                case .pickerData:
                    guard let titles = Titles(rawValue: title) else {
                        assertionFailure("Unknown title: \(title)")
                        break
                    }
                    switch titles {
                    case .currency:
                        array.append(PickerData(title: title, value: value, items: Currencies().allCurrencies))
                    case .country:
                        array.append(PickerData(title: title, value: value, items: IsoCountries.allCountries))

                    // managed recurring
                    case .recurringMode:
                        array.append(PickerData(title: title, value: value,
                                                items: ManagedRecurringMode.allCases.map { EnumPickerItem($0.rawValue) }))
                    case .autoRecurringInterval:
                        array.append(PickerData(title: title, value: value,
                                                items: ManagedRecurringParams.Automatic.IntervalValues.allCases.map { EnumPickerItem($0.rawValue) }))
                    case .manualRecurringPaymentType:
                        array.append(PickerData(title: title, value: value,
                                                items: ManagedRecurringParams.Manual.PaymentTypeValues.allCases.map { EnumPickerItem($0.rawValue) }))
                    case .manualRecurringAmountType:
                        array.append(PickerData(title: title, value: value,
                                                items: ManagedRecurringParams.Manual.AmountTypeValues.allCases.map { EnumPickerItem($0.rawValue) }))
                    case .manualRecurringFrequency:
                        array.append(PickerData(title: title, value: value,
                                                items: ManagedRecurringParams.Manual.FrequencyValues.allCases.map { EnumPickerItem($0.rawValue) }))
                    case .manualRecurringValidated:
                        array.append(PickerData(title: title, value: value,
                                                items: BooleanChoice.allCases.map { EnumPickerItem($0.rawValue) }))

                    // 3DS
                    case .challengeIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.ControlParams.ChallengeIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .challengeWindowSize:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.ControlParams.ChallengeWindowSizeValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .category:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.PurchaseParams.CategoryValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .shippingIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.MerchantRiskParams.ShippingIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .deliveryTimeframe:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.MerchantRiskParams.DeliveryTimeframeValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .reorderItemsIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.MerchantRiskParams.ReorderItemsIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .preOrderPurchaseIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.MerchantRiskParams.PreOrderPurchaseIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .giftCard:
                        array.append(PickerData(title: title, value: value,
                                                items: BooleanChoice.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .updateIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.CardHolderAccountParams.UpdateIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .passwordChangeIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.CardHolderAccountParams.PasswordChangeIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .shippingAddressUsageIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.CardHolderAccountParams.ShippingAddressUsageIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .suspiciousActivityIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.CardHolderAccountParams.SuspiciousActivityIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    case .registrationIndicator:
                        array.append(PickerData(title: title, value: value,
                                                items: ThreeDSV2Params.CardHolderAccountParams.RegistrationIndicatorValues.allCases
                                                            .map { EnumPickerItem($0.rawValue) }))
                    default:
                        break
                    }
                }
            }
        }
        return array
    }
}
