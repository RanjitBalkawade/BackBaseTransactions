//
//  TransactionsListViewController.swift
//  Transactions
//
//  Created by Backbase R&D B.V on 29/12/2022.
//

import UIKit
import BackbaseMDS

class TransactionsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = TransactionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
        viewModel.fetchTransactions() { [weak self] result in
            switch result {
                case .success:
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.description)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = BackbaseUI.shared.colors.foundation
        self.title = viewModel.title
    }
    
    private func setupTableView() {
        tableView.backgroundColor = BackbaseUI.shared.colors.foundation
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension TransactionsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pendingTransactionsCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
        cell.configure(with: viewModel.pendingTransactionsCellViewModels[indexPath.row])
        return cell
    }
    
}


extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TransactionsTableSectionHeaderView()
        headerView.configure(title: "Section \(section)")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
