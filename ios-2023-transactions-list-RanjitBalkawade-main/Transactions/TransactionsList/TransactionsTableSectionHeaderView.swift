//
//  TransactionsTableSectionHeaderView.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import UIKit
import BackbaseMDS

/// Custom `UIView` subclass representing the header view for sections in a transactions table.
class TransactionsTableSectionHeaderView: UIView {
    
    // MARK: - Private properties
    
    /// A label used to display the title for the section header.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.font = BackbaseUI.shared.fonts.preferredFont(.title2, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    /// Initializes the view with the specified frame.
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    /// Initializes the view from a storyboard or nib file.
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Internal methods
    
    /// Configures the header view with a title.
    /// - Parameter title: The text to be displayed as the section header title.
    func configure(title: String?) {
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    
    /// Sets up the view by adding the title label and applying layout constraints.
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
