//
//  TransactionsCell.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 14/10/2024.
//

import UIKit
import BackbaseMDS

class TransactionCell: UITableViewCell {
    
    //MARK: - Internal properties
    
    static let reuseIdentifier = "TransactionCell"
    
    //MARK: - Private properties
    
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
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = BackbaseUI.shared.spacers.sm
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = BackbaseUI.shared.spacers.sm
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let transactionCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.font = BackbaseUI.shared.fonts.preferredFont(.footnote, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.textAlignment = .right
        label.font = BackbaseUI.shared.fonts.preferredFont(.footnote, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = BackbaseUI.shared.colors.textSupport
        label.font = BackbaseUI.shared.fonts.preferredFont(.footnote, .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = BackbaseUI.shared.colors.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = BackbaseUI.shared.colors.textDefault
        label.font = BackbaseUI.shared.fonts.preferredFont(.headline, .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Life cycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        transactionCountLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.attributedText = nil
        amountLabel.text = nil
    }
    
    //MARK: - Internal methods
    
    func configure(with viewModel: TransactionCellViewModel) {
        iconImageView.image = viewModel.icon
        iconImageView.tintColor = BackbaseUI.shared.colors.primary
        transactionCountLabel.text = viewModel.transactionCount
        dateLabel.text = viewModel.date
        descriptionLabel.attributedText = NSMutableAttributedString(string: viewModel.description)
        amountLabel.text = viewModel.amount
        amountLabel.textColor = viewModel.amountColor
    }
    
    //MARK: - Private methods
    
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
