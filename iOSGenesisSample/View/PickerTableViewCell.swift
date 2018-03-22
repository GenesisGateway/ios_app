//
//  PickerTableViewCell.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

final class PickerTableViewCell: UITableViewCell {

    @IBOutlet weak var inputTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    var delegate: CellDidChangeDelegate?
    
    var data: PickerData! {
        didSet {
            inputTitleLabel.text = data.title
            inputTextField.text = data.value
            
            picker = UIPickerView.init(frame: .zero)
            picker?.dataSource = self
            picker?.delegate = self
            inputTextField.inputView = picker
        }
    }
    var indexPath: IndexPath!
    
    var picker: UIPickerView?
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.items.count;
    }
}

// MARK: - UIPickerViewDelegate
extension PickerTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = data.items[row]
        return item.pickerTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = data.items[row]
        inputTextField.text = item.pickerValue

        delegate?.cellTextFieldDidChange(value: item.pickerValue, IndexPath: indexPath)
    }
}
