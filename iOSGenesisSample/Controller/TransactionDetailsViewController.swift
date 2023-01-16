//
//  TransactionDetailsViewController.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

protocol CellDidChangeDelegate: AnyObject {
    func cellTextFieldDidChange(value: Any, indexPath: IndexPath)
    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField)
    func cellTextFieldValidationPassed(_ indexPath: IndexPath)
}

final class TransactionDetailsViewController: UIViewController {

    var transactionName: TransactionName? {
        didSet {
            if let name = transactionName {
                inputData = InputData(transactionName: name)
            } else {
                assertionFailure("TransactionName must be set")
            }
        }
    }
    
    @IBOutlet private weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    private var inputData: InputData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: .UIKeyboardWillHide, object: nil)
    
        hideKeyboardWhenTappedAround()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

private extension TransactionDetailsViewController {

    var data: [GenesisSwift.DataProtocol] {
        inputData.objects
    }

    @objc func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        guard isViewVisible() else { return }
        
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
                       animations: { self.view.layoutIfNeeded() }
        )
    }
    
    func showPayForm() {

        let paymentRequest = inputData.createPaymentRequest()

        //Credentials for Genesis
        let credentials = Credentials(withUsername: "YOUR_USERNAME", andPassword: "YOUR_PASSWORD")

        //Configuration for Genesis
        let configuration = Configuration(credentials: credentials, language: .en, environment: .staging, endpoint: .emerchantpay)
        
        //Init Genesis with Configuration and PaymentRequest
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
        data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.count {
            return tableView.dequeueReusableCell(withIdentifier: "PayTableViewCell", for: indexPath)
        } else {
            let rowData = data[indexPath.row]

            if let data = rowData as? PickerData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
                cell.data = data
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell
                cell.data = rowData
                cell.indexPath = indexPath
                cell.delegate = self
                
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension TransactionDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == data.count {
            guard inputData.amount.value.explicitConvertionToDecimal() != nil else {
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
        // empty
    }

    func genesisDidEndWithSuccess() {
        presentAlertWithTitle("Success", andMessage: "Success transaction")
    }

    func genesisDidEndWithFailure(errorCode: GenesisError) {
        let message = "code: \(errorCode.code ?? "unknown")\n technical: \(errorCode.technicalMessage ?? "unknown")\n message: \(errorCode.message ?? "unknown")"
        presentAlertWithTitle("Failure", andMessage: message)
    }

    func genesisDidEndWithCancel() {
        presentAlertWithTitle("Canceled")
    }
    
    func genesisValidationError(error: GenesisValidationError) {
        print(error.errorUserInfo)
        presentAlertWithTitle("SDK Validation error", andMessage: error.localizedDescription)
    }
}

// MARK: - CellDidChangeDelegate
extension TransactionDetailsViewController: CellDidChangeDelegate {
    
    func cellTextFieldDidChange(value: Any, indexPath: IndexPath) {
        var dataObject = data[indexPath.row]
        dataObject.value = value as! String

        inputData.save()

        switch InputData.Titles(rawValue: dataObject.title) {
        case .recurringMode:
            // user must fill in different values depending on the managed recurring mode
            tableView.reloadData()
        default:
            break
        }
    }
    
    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField) {
        textField.becomeFirstResponder()
        presentAlertWithTitle("Validation error", andMessage: "for: \(data[indexPath.row].title)")
    }
    
    func cellTextFieldValidationPassed(_ indexPath: IndexPath) {
        // empty
    }
}
