//
//  HomeViewController.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

class HomeViewController: UIViewController {
    
    let transactionTypes: [TransactionName] = [.authorize, .sale, .sale3d, .paysafecard].sorted(by: { $0.rawValue < $1.rawValue })
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func descriptionForTransactionName(transactionName: TransactionName) -> String {
        switch transactionName.rawValue {
        case TransactionName.sale.rawValue: return "Sale"
        case TransactionName.sale3d.rawValue: return "Sale3D"
        case TransactionName.authorize.rawValue: return "Authorize"
        case TransactionName.paysafecard.rawValue: return "Paysafecard"
            
        default: return transactionName.rawValue
        }
    }
    
    @IBAction func privacyPolicyButtonPressed() {
        openURLString(urlString: "https://www.genesissupport247.com/privacy-policy/")
    }
    
    @IBAction func termsAndConditionsButtonPressed() {
        openURLString(urlString: "https://www.genesissupport247.com/terms-conditions/")
    }
    
    private func openURLString(urlString: String) {
        UIApplication.shared.openURL(URL(string: urlString)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TransactionDetailsSegue" {
            let transactionDetails = segue.destination as! TransactionDetailsViewController
            let transaction = transactionTypes[(tableView.indexPathForSelectedRow?.row)!]
            transactionDetails.transactionName = transaction
            transactionDetails.title = descriptionForTransactionName(transactionName: transaction)
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

        cell.textLabel?.text = descriptionForTransactionName(transactionName: transaction)
        
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
