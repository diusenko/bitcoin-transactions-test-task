//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

// MARK: - Protocol

protocol Coordinator: UINavigationController, Attachable {
    func attach(with viewModel: ViewModel)
}

final class AppCoordinator<ViewModel: AppCoordinatorViewModel>: UINavigationController, Coordinator {
    
    // MARK: - Private Properties
    
    private var viewModel: ViewModel?
    private var cancellable: AnyCancellable?
    
    // MARK: - Deinit
    
    deinit {
        self.cancelSubsribtion()
    }
    
    // MARK: - Internal Functions
    
    func start() { }
    
    func attach(with viewModel: ViewModel) {
        self.viewModel = viewModel
        let cancellable = self.viewModel?.events?.sink { _ in }
        self.cancellable = cancellable
    }
    
    // MARK: - Private Functions
    
    private func cancelSubsribtion() {
        self.cancellable?.cancel()
    }
}
