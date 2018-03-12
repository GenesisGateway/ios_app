//
//  TransactionDetailsViewController.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

protocol CellDidChangeDelegate: class {
    func cellTextFieldDidChange(value: Any, IndexPath: IndexPath)
    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField)
    func cellTextFieldValidationPassed(_ indexPath: IndexPath)
}

final class TransactionDetailsViewController: UIViewController {
    var transactionType: TransactionName?
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var data = InputData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        hideKeyboardWhenTappedAround()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIViewAnimationOptions.init(rawValue: UInt(rawAnimationCurve))
        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    func showPayForm() {
        //WPFPaymentAddress for Genesis
        let paymentAddress = WPFPaymentAddress(firstName: data.firstName.value,
                                               lastName: data.lastName.value,
                                               address1: data.address1.value,
                                               address2: data.address2.value,
                                               zipCode: data.zipCode.value,
                                               city: data.city.value,
                                               state: data.state.value,
                                               country: IsoCountryCodes.search(byName: data.country.value))
        
        //WPFPaymentRequest for Genesis
        let paymentRequest = WPFPaymentRequest(transactionId: data.transactionId.value,
                                               amount: data.amount.value.explicitConvertionToDecimal()!,
                                               currency: Currencies.findCurrencyInfoByName(name: data.currency.value)!,
                                               customerEmail: data.customerEmail.value,
                                               customerPhone: data.customerPhone.value,
                                               billingAddress: paymentAddress,
                                               transactionTypes: [transactionType!],
                                               notificationUrl: data.notificationUrl.value)
        
        //Credentials for Genesis
        let credentials = Credentials(withUsername: "YOUR_USERNAME", andPassword: "YOUR_PASSWORD")

        //Configuration for Genesis
        let configuration = Configuration(credentials: credentials, language: .en, environment: .staging, endpoint: .emerchantpay)
        
        //Init Genesis with Configuration and WPFPaymentRequest
        let genesis = Genesis(withConfiguration: configuration, paymentRequest: paymentRequest, forDelegate: self)
        
        //show Genesis payment form
        //Push to navigation controller
        genesis.push(toNavigationController: navigationController!, animated: true)
        
        //Present to modal view
        //genesis.present(toViewController: self, animated: true)
        
        //Use genesis.genesisViewController() and show how you want
        //guard let genesisViewController = genesis.genesisViewController() else {
        //    return
        //}
        //show(genesisViewController, sender: nil)
    }
}

// MARK: - UITableViewDataSource
extension TransactionDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.allObjects.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == data.allObjects.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayTableViewCell", for: indexPath)
            return cell
        } else {
            
            let rowData = data.allObjects[indexPath.row]
            
            if rowData is InputDataObject || rowData is ValidatedInputData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell
                
                cell.data = rowData as! DataProtocol
                cell.indexPath = indexPath
                cell.delegate = self
                
                return cell
            }
            
            if rowData is PickerData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
                
                cell.data = rowData as! PickerData
                cell.indexPath = indexPath
                cell.delegate = self
                
                return cell
            }
            
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension TransactionDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == data.allObjects.count) {
            guard (data.amount.value.explicitConvertionToDecimal() != nil) else {
                presentAlertWithTitle("Amount error")
                return
            }
            
            showPayForm()
        }
    }
}

// MARK: - GenesisDelegate
extension TransactionDetailsViewController: GenesisDelegate {

    func genesisDidFinishLoading() {

    }

    func genesisDidEndWithSuccess() {
        presentAlertWithTitle("Success", andMessage: "Success transaction")
    }

    func genesisDidEndWithFailure(errorCode: GenesisError) {
        presentAlertWithTitle("Failure", andMessage: "code: \(errorCode.code ?? "unknown")\n technical: \(errorCode.technicalMessage ?? "unknown")\n message: \(errorCode.message ?? "unknown")")
    }

    func genesisDidEndWithCancel() {
        presentAlertWithTitle("Canceled")
    }
    
    func genesisValidationError(error: Error) {
        presentAlertWithTitle("SKD Validation error", andMessage: error.localizedDescription)
    }
}

// MARK: - CellDidChangeDelegate
extension TransactionDetailsViewController: CellDidChangeDelegate {
    
    func cellTextFieldDidChange(value: Any, IndexPath: IndexPath) {
        var dataObject = data.allObjects[IndexPath.row] as! DataProtocol
        dataObject.value = value as! String

        data.save()
    }
    
    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField) {
        textField.becomeFirstResponder()
        presentAlertWithTitle("Validation error", andMessage: "for: \((data.allObjects[indexPath.row] as! DataProtocol).title)")
    }
    
    func cellTextFieldValidationPassed(_ indexPath: IndexPath) {
        
    }
}
