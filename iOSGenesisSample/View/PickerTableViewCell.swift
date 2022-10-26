//
//  PickerTableViewCell.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

final class PickerTableViewCell: UITableViewCell {

    @IBOutlet private weak var inputTitleLabel: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    
    var data: PickerData! {
        didSet {
            inputTitleLabel.text = data.title
            inputTextField.text = data.value
            
            picker = UIPickerView(frame: .zero)
            picker?.dataSource = self
            picker?.delegate = self
            inputTextField.inputView = picker
        }
    }

    var indexPath: IndexPath!
    var picker: UIPickerView?
    var delegate: CellDidChangeDelegate?
}

// MARK: - UITextFieldDelegate
extension PickerTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let indices = data.items.enumerated().filter { (offset, item) -> Bool in
            item.pickerValue == data.value
            }.map { (offset, item) -> Int in
                return offset
        }
        
        guard let index = indices.first else { return }
        picker?.selectRow(index, inComponent: 0, animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension PickerTableViewCell: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.items.count
    }
}

// MARK: - UIPickerViewDelegate
extension PickerTableViewCell: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data.items[row].pickerTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = data.items[row]
        inputTextField.text = item.pickerValue

        delegate?.cellTextFieldDidChange(value: item.pickerValue, IndexPath: indexPath)
    }
}
