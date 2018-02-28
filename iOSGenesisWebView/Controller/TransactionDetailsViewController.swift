//
//  TransactionDetailsViewController.swift
//  iOSGenesisWebView
//

import UIKit
import GenesisSwift

protocol CellDidChangeDelegate: class {
    func cellTextFieldDidChange(_: (DataProtocol, IndexPath))
    func cellTextFieldValidationError(_ indexPath: IndexPath)
    func cellTextFieldValidationPassed(_ indexPath: IndexPath)
}

final class TransactionDetailsViewController: UIViewController {
    var transactionType: TransactionName?
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var webViewController: WebViewController?
    
    var requestModel: WPFPaymentRequest!
    var genesisWebView: GenesisWebView!
    
    let userDefaultsKey = "UserDefaultsDataKey"
    
    private var _loadedInputDataSource: Array<DataProtocol>?
    var loadedInputDataSource: Array<DataProtocol> {
        get {
            guard let loaded = UserDefaults.standard.array(forKey: userDefaultsKey) else {
                return InputDataHelper.inputDataDefault
            }
            if _loadedInputDataSource == nil {
                _loadedInputDataSource = InputDataHelper.convertArrayToInputData(inputArray: loaded as! Array<Dictionary<String, String>>)
                _loadedInputDataSource![0] = InputData(title:"transactionId", value: "wev238f328nc" + String(arc4random_uniform(999999)))
            }
            return _loadedInputDataSource!
        }
        set (newData) {
            _loadedInputDataSource = newData
            UserDefaults.standard.set(InputDataHelper.convertInputDataToArray(inputArray:_loadedInputDataSource!), forKey: userDefaultsKey)
        }
    }
    
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
    
    private func isoCodeForCountryName(_ name: String) -> String {
        if let i = IsoCountries.allCountries.index(where: { $0.name == name }) {
            return IsoCountries.allCountries[i].alpha2
        }
        
        return name
    }
    
    func makeRequest() {
    
        guard let amount = loadedInputDataSource[1].value.explicitConvertionToDecimal() else {
            presentAlertWithTitle("Amount error")
            return
        }
        
        requestModel = WPFPaymentRequest(transactionId: loadedInputDataSource[0].value,
                                         amount: amount,
                                         currency: loadedInputDataSource[2].value,
                                         customerEmail: loadedInputDataSource[3].value,
                                         customerPhone: loadedInputDataSource[4].value,
                                         billingAddress: WPFPaymentAddress(firstName: loadedInputDataSource[5].value,
                                                                           lastName: loadedInputDataSource[6].value,
                                                                           address1: loadedInputDataSource[7].value,
                                                                           address2: loadedInputDataSource[8].value,
                                                                           zipCode: loadedInputDataSource[9].value,
                                                                           city: loadedInputDataSource[10].value,
                                                                           state: loadedInputDataSource[11].value,
                                                                           country: self.isoCodeForCountryName(loadedInputDataSource[12].value)),
                                         transactionTypes: [WPFPaymentTransactionType(name: transactionType!)],
                                         notificationUrl: loadedInputDataSource[13].value)
        
        let credentials = Credentials(withUsername: "YOUR_USERNAME", andPassword: "YOUR_PASSWORD")
        
        let configuration = Configuration(credentials: credentials, language: .en, environment: .staging, endpoint: .emerchantpay)
        genesisWebView = GenesisWebView(configuration: configuration, request: requestModel)
        genesisWebView.genesisWebViewDelegate = self
        genesisWebView.loadRequest()

        webViewController = WebViewController()
        navigationController?.pushViewController(webViewController!, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TransactionDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedInputDataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == loadedInputDataSource.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayTableViewCell", for: indexPath)
            return cell
        } else {
            
            let data: DataProtocol = loadedInputDataSource[indexPath.row]
            
            if data is InputData || data is ValidatedInputData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell
                
                cell.data = data
                cell.indexPath = indexPath
                cell.delegate = self
                
                return cell
            }
            
            if data is PickerData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
                
                cell.data = data as! PickerData
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
        if (indexPath.row == loadedInputDataSource.count) {
            makeRequest()
        }
    }
}

// MARK: - GenesisWebViewProtocol
extension TransactionDetailsViewController: GenesisWebViewDelegate {
    
    func genesisWebViewDidFinishLoading() {
        webViewController?.indicator.stopAnimating()
        webViewController?.addView(genesisWebView.webView)
    }
    
    func genesisWebViewDidEndWithSuccess() {
        webViewController?.back()
        
        presentAlertWithTitle("Success", andMessage: "Success redirection")
    }
    
    func genesisWebViewDidEndWithFailure(errorCode: GenesisErrorCode) {
        webViewController?.back()
        
        presentAlertWithTitle("Failure", andMessage: "code: \(errorCode.code ?? "unknown")\n technical: \(errorCode.technicalMessage ?? "unknown")\n message: \(errorCode.message ?? "unknown")")
    }
    
    func genesisWebViewDidEndWithCancel() {
        webViewController?.back()
        
        presentAlertWithTitle("Canceled")
    }
}

// MARK: - CellDidChangeDelegate
extension TransactionDetailsViewController: CellDidChangeDelegate {
 
    func cellTextFieldDidChange(_ tuple: (DataProtocol, IndexPath)) {
        let (dataProtocol, indexPath) = tuple
        var tmpArray = loadedInputDataSource
        tmpArray[indexPath.row] = dataProtocol
        loadedInputDataSource = tmpArray
    }
    
    func cellTextFieldValidationError(_ indexPath: IndexPath) {
        presentAlertWithTitle("Validation error", andMessage: "for: \(loadedInputDataSource[indexPath.row].title)")
    }
    
    func cellTextFieldValidationPassed(_ indexPath: IndexPath) {
        
    }
}
