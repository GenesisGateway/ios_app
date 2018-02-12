//
//  ViewController.swift
//  iOSGenesisWebView
//

import UIKit
import GenesisSwift

protocol CellDidChangeDelegate: class {
    func cellTextFieldDidChange(_: (DataProtocol, IndexPath))
    func cellTextFieldValidationError(_ indexPath: IndexPath)
    func cellTextFieldValidationPassed(_ indexPath: IndexPath)
}

final class ViewController: UIViewController {
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var webViewController: WebViewController?
    
    var requestModel: WPFPaymentRequest!
    var genesisWebView: GenesisWebView!
    
    let userDefaultsKey = "UserDefaultsDataKey"
    
    let inputDataSource: [DataProtocol] = [
        InputData(title: "transactionId", value: "wev238f328nc" + String(arc4random_uniform(999999))),
        ValidatedInputData(title:"amount", value: "1,234.56", regex: "[0-9]{1,3}(,[0-9]{3})*.[0-9]{0,3}"),
        PickerData(title:"currency", value: "USD", items: Currencies.allCurrencies),
        InputData(title:"customerEmail", value: "john.doe@example.com"),
        InputData(title:"customerPhone", value: "+11234567890"),
        InputData(title:"firstName", value: "John"),
        InputData(title:"lastName", value: "Doe"),
        InputData(title:"address1", value: "23, Doestreet"),
        InputData(title:"address2", value: ""),
        InputData(title:"zipCode", value: "11923"),
        InputData(title:"city", value: "New York City"),
        InputData(title:"state", value: "NY"),
        PickerData(title:"country", value: "US", items: IsoCountries.allCountries),
        InputData(title:"notificationUrl", value: "https://example.com/notification")]
    
    private var _loadedInputDataSource: Array<DataProtocol>?
    var loadedInputDataSource: Array<DataProtocol> {
        get {
            guard let loaded = UserDefaults.standard.array(forKey: userDefaultsKey) else {
                return inputDataSource
            }
            if _loadedInputDataSource == nil {
                _loadedInputDataSource = convertArrayToInputData(inputArray: loaded as! Array<Dictionary<String, String>>)
                _loadedInputDataSource![0] = InputData(title:"transactionId", value: "wev238f328nc" + String(arc4random_uniform(999999)))
            }
            return _loadedInputDataSource!
        }
        set (newData) {
            _loadedInputDataSource = newData
            UserDefaults.standard.set(convertInputDataToArray(inputArray:_loadedInputDataSource!), forKey: userDefaultsKey)
        }
    }
    
    func convertInputDataToArray(inputArray: Array<DataProtocol>) -> Array<Dictionary<String, String>> {
        var array = Array<Dictionary<String, String>>()
        for data in inputArray {
            var dictionary = Dictionary<String, String>()
            dictionary["title"] = data.title
            dictionary["value"] = data.value
            dictionary["regex"] = data.regex
            dictionary["type"] = String(describing: type(of: data))
            array.append(dictionary)
        }
        return array
    }
    
    func convertArrayToInputData(inputArray: Array<Dictionary<String, String>>) -> Array<DataProtocol> {
        var array = Array<DataProtocol>()
        var counter = 0
        for dictionary in inputArray {
            if let title = dictionary["title"], let value = dictionary["value"], let regex = dictionary["regex"], let type = dictionary["type"] {
                if type == "InputData" {
                    array.append(InputData(title: title, value: value))
                }
                if type == "PickerData" {
                    if counter == 0 {
                        array.append(PickerData(title: title, value: value, items: Currencies.allCurrencies))
                    }
                    if counter == 1 {
                        array.append(PickerData(title: title, value: value, items: IsoCountries.allCountries))
                    }
                    counter += 1
                }
                if type == "ValidatedInputData" {
                    array.append(ValidatedInputData(title: title, value: value, regex: regex))
                }
            }
        }
        return array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
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
    
    func makeRequest() {
    
        guard let amount = loadedInputDataSource[1].value.explicitConvertionToDecimal() else {
            showAlertWithTitle("Amount error", message: "")
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
                                                                           country: loadedInputDataSource[12].value),
                                         transactionTypes: [WPFPaymentTransactionType(name: .sale)],
                                         notificationUrl: loadedInputDataSource[13].value)
        
        let credentials = "YOUR_USERNAME:YOUR_PASSWORD"
        
        let configuration = Configuration(credentials: credentials, language: .en, environment: .staging, endpoint: .emerchantpay)
        genesisWebView = GenesisWebView(configuration: configuration, request: requestModel)
        genesisWebView.genesisWebViewDelegate = self
        genesisWebView.loadRequest()

        webViewController = WebViewController()
        navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
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
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == loadedInputDataSource.count) {
            makeRequest()
        }
    }
}

// MARK: - GenesisWebViewProtocol
extension ViewController: GenesisWebViewDelegate {
    
    func genesisWebViewDidFinishLoading() {
        webViewController?.indicator.stopAnimating()
        webViewController?.addView(genesisWebView.webView)
    }
    
    func genesisWebViewDidEndWithSuccess() {
        webViewController?.back()
        let alert = UIAlertController(title: "Success", message: "Success redirection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func genesisWebViewDidEndWithFailure(errorCode: GenesisErrorCode) {
        webViewController?.back()
        let alert = UIAlertController(title: "Failure",
                                      message: "code: \(errorCode.code ?? "unknown")\n technical: \(errorCode.technicalMessage ?? "unknown")\n message: \(errorCode.message ?? "unknown")",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func genesisWebViewDidEndWithCancel() {
        webViewController?.back()
        let alert = UIAlertController(title: "Canceled", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - CellDidChangeDelegate
extension ViewController: CellDidChangeDelegate {
 
    func cellTextFieldDidChange(_ tuple: (DataProtocol, IndexPath)) {
        let (dataProtocol, indexPath) = tuple
        var tmpArray = loadedInputDataSource
        tmpArray[indexPath.row] = dataProtocol
        loadedInputDataSource = tmpArray
    }
    
    func cellTextFieldValidationError(_ indexPath: IndexPath) {
        showAlertWithTitle("Validation error", message: "for: \(loadedInputDataSource[indexPath.row].title)")
    }
    
    func cellTextFieldValidationPassed(_ indexPath: IndexPath) {
        
    }
}
