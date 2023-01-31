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
            inputTextField.text = data.items.first { $0.pickerValue == data.value }?.pickerTitle ?? data.value
            
            picker = UIPickerView(frame: .zero)
            picker?.dataSource = self
            picker?.delegate = self
            inputTextField.inputView = picker
            inputTextField.tintColor = .clear
        }
    }

    var indexPath: IndexPath!
    private var picker: UIPickerView?
    weak var delegate: CellDidChangeDelegate?
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
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
        inputTextField.text = item.pickerTitle

        delegate?.cellTextFieldDidChange(value: item.pickerValue, indexPath: indexPath)
    }
}
