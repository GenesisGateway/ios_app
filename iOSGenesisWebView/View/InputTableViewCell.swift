//
//  InputTableViewCell.swift
//  iOSGenesisWebView
//

import UIKit
import GenesisSwift

final class InputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inputTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    var delegate: CellDidChangeDelegate?
 
    var _data: DataProtocol!
    var data: DataProtocol! {
        didSet {
            inputTitleLabel.text = data.title
            inputTextField.text = data.value
            _data = data
        }
    }
    var indexPath: IndexPath!
}

// MARK: - UITextFieldDelegate
extension InputTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _data.value = _data.value.replacingCharacters(in: Range(range, in: _data.value)!,
                                                      with: string)
        delegate?.cellTextFieldDidChange((_data, indexPath))
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if data is ValidatedInputData {
            let predicate = NSPredicate(format:"SELF MATCHES %@", data.regex)
            let evaluation = predicate.evaluate(with: inputTextField.text!)
            if evaluation == false {
                delegate?.cellTextFieldValidationError(indexPath)
            } else {
                delegate?.cellTextFieldValidationPassed(indexPath)
            }
        }
    }
}
