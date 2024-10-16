//
//  TransactionsListViewController.swift
//  Transactions
//
//  Created by Backbase R&D B.V on 29/12/2022.
//

import UIKit
import Combine
import BackbaseMDS
import BackbaseNetworking

class TransactionsListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var pendingTransactions: [Transaction] = []
    var completedTransactions: [Transaction] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackbaseUI.shared.colors.foundation
        self.title = "Transactions"
        
        setupTableView()
        bindData()
    }
    
    // Setup table view
    private func setupTableView() {
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = BackbaseUI.shared.colors.foundation
    }
    

    private func bindData() {
        TransactionsAPI().getTransactions(userId: 10015)
            .map { $0 }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .finished:
                        break
                }
            }, receiveValue: { [weak self] transactions in
                self?.completedTransactions = transactions
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        completedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
        cell.configure(with: completedTransactions[indexPath.row])
        return cell
    }
}


extension TransactionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomTableSectionHeaderView()
        headerView.configure(title: "Section \(section)")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
