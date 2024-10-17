//
//  TransactionsListViewController.swift
//  Transactions
//
//  Created by Backbase R&D B.V on 29/12/2022.
//

import UIKit
import BackbaseMDS

class TransactionsListViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var viewModel = TransactionsListViewModel()
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        loadData()
    }
    
    //MARK: - Private methods
    
    // Method to load data
    private func loadData() {
        viewModel.fetchTransactions { [weak self] result in
            switch result {
                case .success:
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(with: error.description)
            }
        }
    }
    
    // Method to show the UIAlertController with Retry button
    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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

//MARK: - UITableViewDataSource

extension TransactionsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.transactionCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactionCellViewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
        cell.configure(with: viewModel.transactionCellViewModels[indexPath.section][indexPath.row])
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TransactionsTableSectionHeaderView()
        headerView.configure(title: viewModel.titleForSection(section))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
