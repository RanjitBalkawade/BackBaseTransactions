//
//  TransactionsTableSectionHeaderView.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import UIKit
import BackbaseMDS

class TransactionsTableSectionHeaderView: UIView {
    
    //MARK: - Private properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.font = BackbaseUI.shared.fonts.preferredFont(.title2, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    //MARK: - Internal methods
    
    func configure(title: String?) {
        titleLabel.text = title
    }
    
    //MARK: - Private methods
    
    private func setupViews() {
        backgroundColor = UIColor.clear
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BackbaseUI.shared.sizers.md),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * BackbaseUI.shared.sizers.md),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: BackbaseUI.shared.sizers.lg),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * BackbaseUI.shared.sizers.sm)
        ])
    }
}
