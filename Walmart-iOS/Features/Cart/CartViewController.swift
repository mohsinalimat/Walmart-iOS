//
//  CartViewController.swift
//  Walmart-iOS
//
//  Created by TriNgo on 3/13/18.
//  Copyright © 2018 TriNgo. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var lbTotalAmount: UILabel!
    @IBOutlet weak var lbTotalItems: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private let CartCellReuseIdentifier = "CartCellReuseIdentifier"
    var dataSources: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        registerCell()
        updateQuantity()
        updateAmount()
    }
    
    private func updateAmount() {
        let totalAmount = dataSources.reduce(0) { $0 + Double($1.quantity) * $1.currentPrice! }
        lbTotalAmount.text = "Total amount: $\(totalAmount)"
    }
    
    private func updateQuantity() {
        let totalItems = dataSources.reduce(0) { $0 + $1.quantity }
        lbTotalItems.text = "\(totalItems) items"
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: CartCellReuseIdentifier)
    }
    
    private func updateCellQuantityLabel(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CartCell {
            cell.lbQuantity.text = String(describing: dataSources[indexPath.row].quantity) 
        }
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CartCellReuseIdentifier, for: indexPath) as? CartCell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.product = dataSources[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

extension CartViewController: CartCellDelegate {
    func onQuantityIncreased(indexPath: IndexPath) {
        dataSources[indexPath.row].quantity += 1
        updateCellQuantityLabel(indexPath: indexPath)
        updateQuantity()
        updateAmount()
    }
    
    func onQuantityDecreased(indexPath: IndexPath) {
        if dataSources[indexPath.row].quantity > 0 {
            dataSources[indexPath.row].quantity -= 1
        }
        updateCellQuantityLabel(indexPath: indexPath)
        updateQuantity()
        updateAmount()
    }
}
