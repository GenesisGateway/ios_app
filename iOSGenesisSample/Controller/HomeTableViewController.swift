//
//  HomeTableViewController.swift
//  iOSGenesisSample
//
//  Created by Ivaylo Hadzhiev on 26.01.23.
//

import UIKit
import GenesisSwift

final class HomeTableViewController: UITableViewController {

    private lazy var configurationData = ConfigurationData()
    private lazy var transactionTypes: [TransactionName] =
        [.authorize, .authorize3d, .sale, .sale3d, .paysafecard, .initRecurringSale, .initRecurringSale3d]
            .sorted(by: { $0.rawValue < $1.rawValue })

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "TransactionDetailsSegue" else { return }
        guard let transactionDetails = segue.destination as? TransactionDetailsViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        let transaction = transactionTypes[row]
        transactionDetails.transactionName = transaction
        transactionDetails.configurationData = configurationData
        transactionDetails.title = description(for: transaction)
    }
}

private extension HomeTableViewController {

    func description(for transactionName: TransactionName) -> String {
        switch transactionName {
        case .initRecurringSale: return "Init Recurring Sale"
        case .initRecurringSale3d: return "Init Recurring Sale3D"
        case .sale: return "Sale"
        case .sale3d: return "Sale3D"
        case .authorize: return "Authorize"
        case .authorize3d: return "Authorize3D"
        case .paysafecard: return "Paysafecard"
        default: return transactionName.rawValue
        }
    }

    @IBAction func privacyPolicyButtonPressed() {
        openURLString(urlString: "https://www.genesissupport247.com/privacy-policy/")
    }

    @IBAction func termsAndConditionsButtonPressed() {
        openURLString(urlString: "https://www.genesissupport247.com/terms-conditions/")
    }

    func openURLString(urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            assertionFailure("Cannot open URL: \(urlString)")
        }
    }
}

extension HomeTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section) {
        case .configuration:
            return configurationData.objects.count
        case .transactionType:
            return transactionTypes.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = Sections(rawValue: section).unwrap(error: "Invalid section: \(section)")
        switch section {
        case .configuration:
            return "Configure account"
        case .transactionType:
            return "Choose transaction type"
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.tintColor = .lightGray
        header.textLabel?.textColor = .black
        header.textLabel?.font = .boldSystemFont(ofSize: 15)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections(rawValue: indexPath.section).unwrap(error: "Invalid section for path: \(indexPath)")
        switch section {
        case .configuration:
            let rowData = configurationData.objects[indexPath.row]
            if let data = rowData as? PickerData {
                let cell: PickerTableViewCell = cell(ofType: .picker, for: indexPath)
                cell.data = data
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            } else {
                let cell: InputTableViewCell = cell(ofType: .input, for: indexPath)
                cell.data = rowData
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            }
        case .transactionType:
            let cell = cell(ofType: .transaction, for: indexPath)
            let transaction = transactionTypes[indexPath.row]
            cell.textLabel?.text = description(for: transaction)
            return cell
        }
    }
}

// MARK: - CellDidChangeDelegate

extension HomeTableViewController: CellDidChangeDelegate {

    func cellTextFieldDidChange(value: Any, indexPath: IndexPath) {
        var dataObject = configurationData.objects[indexPath.row]
        dataObject.value = value as! String
        configurationData.save()
    }

    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField) {
        textField.becomeFirstResponder()
        presentAlertWithTitle("Validation error", andMessage: "for: \(configurationData.objects[indexPath.row].title)")
    }

    func cellTextFieldValidationPassed(_ indexPath: IndexPath) {
        // empty
    }
}

private extension HomeTableViewController {

    enum Sections: Int, CaseIterable {
        case configuration
        case transactionType
    }

    enum TableViewCellTypes: String {
        case input = "InputTableViewCell"
        case picker = "PickerTableViewCell"
        case transaction = "TransactionTypeCell"
    }

    func cell<T: UITableViewCell>(ofType type: TableViewCellTypes, for indexPath: IndexPath) -> T {
        (tableView.dequeueReusableCell(withIdentifier: type.rawValue, for: indexPath) as? T)
            .unwrap(error: "Failed to create a cell with identifer: \(type.rawValue) for indexPath: \(indexPath)")
    }
}
