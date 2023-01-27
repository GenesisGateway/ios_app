//
//  HomeViewController.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private lazy var transactionTypes: [TransactionName] =
    [.authorize, .authorize3d, .sale, .sale3d, .paysafecard, .initRecurringSale, .initRecurringSale3d].sorted(by: { $0.rawValue < $1.rawValue })

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
        transactionDetails.title = description(for: transaction)
    }
}

private extension HomeViewController {

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

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTypeCell", for: indexPath)
        let transaction = transactionTypes[indexPath.row]
        cell.textLabel?.text = description(for: transaction)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TransactionDetailsSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
