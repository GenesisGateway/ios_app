//
//  InputTableViewCell.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

final class InputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inputTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    var delegate: CellDidChangeDelegate?
 
    var data: DataProtocol! {
        didSet {
            inputTitleLabel.text = data.title
            inputTextField.text = data.value
        }
    }
    var indexPath: IndexPath!
}

// MARK: - UITextFieldDelegate
extension InputTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
        
            delegate?.cellTextFieldDidChange(value: updatedText, IndexPath: indexPath)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if data is ValidatedInputData {
            let predicate = NSPredicate(format:"SELF MATCHES %@", data.regex)
            let evaluation = predicate.evaluate(with: inputTextField.text!)
            if evaluation == false {
                delegate?.cellTextFieldValidationError(indexPath, textField: inputTextField)
            } else {
                delegate?.cellTextFieldValidationPassed(indexPath)
            }
        }
    }
}
