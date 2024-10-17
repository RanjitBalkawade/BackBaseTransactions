//
//  TransactionsListViewController.swift
//  Transactions
//
//  Created by Backbase R&D B.V on 29/12/2022.
//

import UIKit
import BackbaseMDS

/// The view controller that manages and displays the list of transactions in a table view.
class TransactionsListViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Private properties
    
    /// Responsible for managing transactions data and providing it to the view
    private var viewModel = TransactionsListViewModel(userId: 10015)
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    
    //MARK: - Private methods
    
    /// Loads data, if successful reloads table View else shows error alert
    private func loadData() {
        showActivityIndicator()
        viewModel.fetchTransactions { [weak self] result in
            self?.hideActivityIndicator()
            switch result {
                case .success:
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(with: error.description)
            }
        }
    }
    
    /// Shows an alert with the error message and options to retry or cancel
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
    
    /// Sets up the initial view of the controller
    private func setupView() {
        view.backgroundColor = BackbaseUI.shared.colors.foundation
        self.title = viewModel.title
        setupTableView()
    }
    
    /// Sets up the table view
    private func setupTableView() {
        tableView.backgroundColor = BackbaseUI.shared.colors.foundation
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func showActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
}

//MARK: - UITableViewDataSource

extension TransactionsListViewController: UITableViewDataSource {
    
    /// Returns the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    /// Returns the number of rows in a given section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems(inSection: section)
    }
    
    /// Configures and returns the cell for a given indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier)
        
        guard let cell = dequeuedCell as? TransactionCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.transactionCellViewModel(forIndexPath: indexPath))
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension TransactionsListViewController: UITableViewDelegate {
    
    /// Returns a custom view for the header of each section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TransactionsTableSectionHeaderView()
        headerView.configure(title: viewModel.titleForSection(section))
        return headerView
    }
    
    /// Sets the height for the header in each section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
