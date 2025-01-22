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
    static let leading: CGFloat = 20
    static let trailing: CGFloat = -20
    static let cornerradius: CGFloat = 12
}

protocol MainView: BaseUIViewImpl { }

final class MainViewImpl: BaseUIViewImpl, MainView {
    
    // MARK: - Lazy computed UI Elements
    
    private lazy var balanceLabel: UILabel = {
        let fontSize = MainViewConstants.fontSize
        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        
        return label
    }()

    private lazy var addBalanceButton: UIButton = {
        let fontSize = MainViewConstants.fontSize
        let button = UIButton(type: .system)
        button.setImage(.add.withTintColor(.green), for: .normal)
        button.layer.cornerRadius = MainViewConstants.cornerradius
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        return button
    }()

    private lazy var addTransactionButton: UIButton = {
        let fontSize = MainViewConstants.fontSize
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.layer.cornerRadius = MainViewConstants.cornerradius
        button.setTitle("Tap Me", for: .normal)
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
        self.setupConstraints()
    }
    
    // MARK: - Private Functions
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(self.stackViewConstraints())
        NSLayoutConstraint.activate(self.tableViewConstraints())
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
