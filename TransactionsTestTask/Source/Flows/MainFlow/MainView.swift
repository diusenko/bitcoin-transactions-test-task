//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 21.01.2025.
//

import UIKit
import Combine

fileprivate struct MainViewConstants {
    static let spacing: CGFloat = 20
    static let fontSize: CGFloat = 16
    static let balanceFontSize: CGFloat = 20
    static let leading: CGFloat = 20
    static let trailing: CGFloat = -20
    static let cornerradius: CGFloat = 12
    static let buttonInset: CGFloat = 8
}

protocol MainView: BaseView {
    func setBpiLabel(text: String)
    func setBalanceLabel(text: String)
}

final class MainViewImpl: BaseUIViewImpl, MainView {
    
    // MARK: - Lazy computed UI Elements
    
    private lazy var bpiLabel: UILabel = {
        let fontSize = MainViewConstants.fontSize
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let fontSize = MainViewConstants.balanceFontSize
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        
        return label
    }()

    private lazy var addBalanceButton: UIButton = {
        let fontSize = MainViewConstants.fontSize
        var configuration = UIButton.Configuration.filled()
        configuration.image = .add
        configuration.baseBackgroundColor = .systemGreen
        configuration.cornerStyle = .large
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        return button
    }()

    private lazy var addTransactionButton: UIButton = {
        let addTransactionTitle = LocalizationConstants
            .MainViewConstants
            .addTransaction
        let inset = MainViewConstants.buttonInset
        let fontSize = MainViewConstants.fontSize
        var configuration = UIButton.Configuration.filled()
        configuration.title = addTransactionTitle
        configuration.baseBackgroundColor = .systemGreen
        configuration.baseForegroundColor = .systemGray6
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: inset,
                                                              leading: inset,
                                                              bottom: inset,
                                                              trailing: inset)
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return button
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.balanceLabel)
        stackView.addArrangedSubview(self.addBalanceButton)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = MainViewConstants.spacing
        
        return stackView
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = MainViewConstants.spacing
        stackView.addArrangedSubview(self.horizontalStackView)
        stackView.addArrangedSubview(self.addTransactionButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Init
    
    override func addSubviews() {
        self.backgroundColor = .white
        self.addSubview(self.verticalStackView)
        self.addSubview(self.tableView)
        self.addSubview(self.bpiLabel)
        self.setupConstraints()
    }
    
    func setBpiLabel(text: String) {
        self.bpiLabel.text = text
    }
    
    func setBalanceLabel(text: String) {
        self.balanceLabel.text = text
    }
    
    // MARK: - Private Functions
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(self.stackViewConstraints())
        NSLayoutConstraint.activate(self.tableViewConstraints())
        NSLayoutConstraint.activate(self.bpiLabelConstraint())
    }
    
    private func bpiLabelConstraint() -> [NSLayoutConstraint] {
        return [
            self.bpiLabel
                .topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.bpiLabel
                .trailingAnchor
                .constraint(equalTo: trailingAnchor,
                            constant: MainViewConstants.trailing)
        ]
    }
    
    private func stackViewConstraints() -> [NSLayoutConstraint] {
       return [
            self.verticalStackView.centerXAnchor
                .constraint(equalTo: centerXAnchor),
            self.verticalStackView.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            self.verticalStackView.leadingAnchor
                .constraint(greaterThanOrEqualTo: leadingAnchor,
                            constant: MainViewConstants.leading),
            self.verticalStackView.trailingAnchor
                .constraint(lessThanOrEqualTo: trailingAnchor,
                            constant: MainViewConstants.trailing),
        ]
    }
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
       return [
        self.tableView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor,
                                            constant: MainViewConstants.spacing),
        self.tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
        self.tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        self.tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
       ]
    }
}
