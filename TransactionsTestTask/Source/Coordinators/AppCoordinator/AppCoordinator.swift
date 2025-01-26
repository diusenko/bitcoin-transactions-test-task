//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

// MARK: - Constants

struct AlertConstants {
    static let title = LocalizationConstants.Alert.title
    static let message = LocalizationConstants.Alert.messageTitle
    static let placeholder = LocalizationConstants.Alert.placeholder
    static let okButtonTitle = LocalizationConstants.Alert.okButtonTitle
    static let cancelButtonTitle = LocalizationConstants.Alert.cancelButtonTitle
}

// MARK: - Protocol
// TODO: - MainViewController to protocol
protocol Coordinator: UINavigationController, ViewModelAttachable {
    func attach(with viewModel: ViewModel)
    func attach(mainViewController: MainViewController<MainViewModelImpl, MainViewImpl>)
}

// MARK: - AppCoordinator

final class AppCoordinator<ViewModel: AppCoordinatorViewModel>: UINavigationController,
                                                                Coordinator {
    
    // MARK: - Final Properties
    
    var mainViewController: MainViewController<MainViewModelImpl, MainViewImpl>?
    
    // MARK: - Private Properties
    
    private var viewModel: ViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Deinit
    
    deinit {
        self.cancelSubsribtion()
        self.viewModel = nil
        self.mainViewController = nil
    }
    
    // MARK: - Internal Functions
    
    func start() { }
    
    func attach(with viewModel: ViewModel) {
        self.viewModel = viewModel
        self.viewModel?.events?.sink { _ in }.store(in: &self.cancellables)
    }
    
    func attach(mainViewController: MainViewController<MainViewModelImpl, MainViewImpl>) {
        self.mainViewController = mainViewController
        mainViewController.events?.sink { [weak self] event in
            switch event {
            case .showRefilBalance:
                self?.showAlertWithTextField(on: mainViewController)
            case .showTransaction: break
            }
        }.store(in: &self.cancellables)
    }
    
    // MARK: - Private Functions
    
    private func cancelSubsribtion() {
        self.cancellables.forEach {
            $0.cancel()
        }
    }
    
    func showAlertWithTextField(on viewController: UIViewController) {
        let alert = UIAlertController(title: AlertConstants.title, message: AlertConstants.message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = AlertConstants.placeholder
            textField.text = ""
        }
        
        alert.addOkTextFieldAction { [weak self] _ in
            if let inputText = alert.textFields?.first?.text {
                let balance = Float(inputText) ?? 0
                self?.viewModel?.change(balance: balance)
            }
        }

        let cancelAction = UIAlertAction(title: AlertConstants.cancelButtonTitle, style: .cancel)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
}
