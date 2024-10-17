//
//  TransactionsCell.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 14/10/2024.
//

import UIKit
import BackbaseMDS

/// Custom `UITableViewCell` subclass representing a transaction cell in the transaction list.
class TransactionCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    /// The reuse identifier used for dequeuing cells of this type.
    static let reuseIdentifier = "TransactionCell"
    
    // MARK: - Private properties
    
    /// A container view that holds the main cell content with styling such as shadow and rounded corners.
    private let containerView: UIView = {
        let view = UIView()
        let shadow = BackbaseUI.shared.shadows.small
        view.layer.shadowColor = shadow.color.cgColor
        view.layer.shadowOpacity = shadow.opacity
        view.layer.shadowOffset = shadow.offset
        view.layer.shadowRadius = shadow.radius
        view.backgroundColor = BackbaseUI.shared.colors.surfacePrimary
        view.layer.cornerRadius = BackbaseUI.shared.radiuses.large
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A vertical stack view that contains the heading stack, description, and amount information.
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = BackbaseUI.shared.spacers.sm
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// A horizontal stack view containing the icon, transaction count, and date labels.
    private let headingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = BackbaseUI.shared.spacers.sm
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// Image view for displaying the transaction icon (credit or debit).
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Label displaying the number of transactions in the group.
    private let transactionCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.font = BackbaseUI.shared.fonts.preferredFont(.footnote, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Label displaying the transaction date.
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.textAlignment = .right
        label.font = BackbaseUI.shared.fonts.preferredFont(.footnote, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Label displaying the transaction description.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = BackbaseUI.shared.colors.textSupport
        label.font = BackbaseUI.shared.fonts.preferredFont(.footnote, .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// A separator view to visually separate the description and amount sections.
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = BackbaseUI.shared.colors.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Label displaying the transaction amount.
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.font = BackbaseUI.shared.fonts.preferredFont(.headline, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    /// Initializes the cell with the provided style and reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    /// Initializes the cell from a storyboard or xib file.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Life cycle methods
    
    /// Prepares the cell for reuse by resetting its content.
    override func prepareForReuse() {
        super.prepareForReuse()
        transactionCountLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.attributedText = nil
        amountLabel.text = nil
    }
    
    // MARK: - Internal methods
    
    /// Configures the cell with the provided `TransactionCellViewModel`.
    /// - Parameter viewModel: The view model containing the transaction data to display.
    func configure(with viewModel: TransactionCellViewModel) {
        iconImageView.image = viewModel.icon
        iconImageView.tintColor = BackbaseUI.shared.colors.primary
        transactionCountLabel.text = viewModel.transactionCount
        dateLabel.text = viewModel.date
        descriptionLabel.attributedText = NSMutableAttributedString(string: viewModel.description)
        amountLabel.text = viewModel.amount
        amountLabel.textColor = viewModel.amountColor
    }
    
    // MARK: - Private methods
    
    /// Sets up the views and their constraints for the cell.
    private func setupViews() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BackbaseUI.shared.sizers.sm),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: BackbaseUI.shared.sizers.md),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * BackbaseUI.shared.sizers.md),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * BackbaseUI.shared.sizers.sm)
        ])
        
        containerView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: BackbaseUI.shared.sizers.md),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: BackbaseUI.shared.sizers.md),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -1 * BackbaseUI.shared.sizers.md),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1 * BackbaseUI.shared.sizers.md)
        ])
        
        mainStackView.addArrangedSubview(headingStackView)
        
        headingStackView.addArrangedSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 11).isActive = true
        
        headingStackView.addArrangedSubview(transactionCountLabel)
        
        headingStackView.addArrangedSubview(dateLabel)
        
        mainStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(separatorView)
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.contentMode = .scaleToFill
        
        mainStackView.addArrangedSubview(amountLabel)
    }
    
}
