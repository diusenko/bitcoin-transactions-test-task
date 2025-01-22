//
//  CustomTableViewCell.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import UIKit

// MARK: - Constants

fileprivate struct CellConstants {
    static let spacing: CGFloat = 10
    static let fontSize: CGFloat = 14
    static let padding: CGFloat = 16
}

// MARK: - CustomTableViewCell

final class CustomTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CellConstants.fontSize)
        label.textColor = .black
        label.numberOfLines = 1
        
        return label
    }()

    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CellConstants.fontSize)
        label.textColor = .darkGray
        label.numberOfLines = 1
        
        return label
    }()

    private lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CellConstants.fontSize)
        label.textColor = .gray
        label.numberOfLines = 1
        
        return label
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.firstLabel,
                                                       self.secondLabel,
                                                       self.thirdLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = CellConstants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.horizontalStackView)
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Setup

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.horizontalStackView
                .leadingAnchor
                .constraint(equalTo: self.contentView.leadingAnchor,
                            constant: CellConstants.padding),
            self.horizontalStackView
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: -CellConstants.padding),
            self.horizontalStackView
                .topAnchor
                .constraint(equalTo: contentView.topAnchor,
                            constant: CellConstants.padding),
            self.horizontalStackView
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor,
                            constant: -CellConstants.padding)
        ])
    }

    // MARK: - Configuration

    func configure(firstText: String, secondText: String, thirdText: String) {
        self.firstLabel.text = firstText
        self.secondLabel.text = secondText
        self.thirdLabel.text = thirdText
    }
}
