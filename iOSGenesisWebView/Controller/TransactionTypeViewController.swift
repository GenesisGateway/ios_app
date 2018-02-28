//
//  TransactionTypeViewController.swift
//  iOSGenesisWebView
//
//  Created by Ivelin Tsankov eMerchantPay on 28.02.18.
//

import UIKit
import GenesisSwift

class TransactionTypeViewController: UIViewController {
    
    let transactionTypes: [TransactionName] = [.authorize, .sale, .sale3d, .paysafecard].sorted(by: { $0.rawValue < $1.rawValue })
    
    //[.authorize, .authorize3d, .sale, .sale3d, .initRecurringSale, .initRecurringSale3d, .ezeewallet, .sofort, .cashu, .paysafecard, .ppro, .paybyvoucherYeepay, .paybyvoucherSale, .neteller, .poli, .p24, .citadelPayin, .idebitPayin, .instaDebitPayin, .paypalExpress, .abnIdeal, .webmoney, .inpay, .sddSale, .sddInitRecurringSale, .trustlySale, .trustlyWithdrawal, .wechat]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    public func descriptionForTransactionName(transactionName: TransactionName) -> String {
        switch transactionName.rawValue {
        case TransactionName.sale.rawValue: return "Sale"
        case TransactionName.sale3d.rawValue: return "Sale3D"
        case TransactionName.authorize.rawValue: return "Authorize"
        case TransactionName.paysafecard.rawValue: return "Paysafecard"
            
        default: return transactionName.rawValue
        }
    }
    
    private func setupView() {
        self.title = "Transaction Types"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TransactionDetailsSegue" {
            let transactionDetails = segue.destination as! TransactionDetailsViewController
            transactionDetails.transactionType = transactionTypes[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

// MARK: - UITableViewDataSource
extension TransactionTypeViewController: UITableViewDataSource {
    
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
extension TransactionTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.performSegue(withIdentifier: "TransactionDetailsSegue", sender: nil)
    }
}
