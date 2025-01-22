//
//  BaseUIView.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import UIKit

protocol IndicatorDisplayable: UIView {
    func showIndicator()
    func hideIndicator()
}

protocol BaseView: IndicatorDisplayable {
    func addSubviews()
}

class BaseUIViewImpl: UIView, BaseView {
    
    // MARK: - Lazy computed UI Elements
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        let indicator = self.activityIndicator
        self.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            /// Will move to const later
            indicator.widthAnchor.constraint(equalToConstant: 50),
            indicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Open Functions
    
    /// Override this method for adding subviews
    /// Do not use init for adding subviews
    open func addSubviews() { }
}

// MARK: - IndicatorDisplayable

extension BaseUIViewImpl {
    
    final func showIndicator() {
        self.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    final func hideIndicator() {
        self.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
}
