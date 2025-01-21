//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import UIKit
import Combine

class BaseViewController<ViewModel: Eventable>: UIViewController, ViewController {
    
    // MARK: - Deinit
    
    /// Canceling subscription.
    deinit {
        self.cancelSubsribtions()
    }
    
    // MARK: - Private Properties
    
    private var cancellable: Set<AnyCancellable> = []
    private(set) var viewModel: ViewModel?
    
    // MARK: - Internal Functions
    
    final func attach(with viewModel: ViewModel) {
        self.viewModel = viewModel
        self.attachNewSubscriptions()
        viewModel.events?.sink { [weak self] events in
            self?.process(events: events)
        }.store(in: &self.cancellable)
    }
    
    // MARK: - Open Functions
    
    /// Override this method for processing events that was produced by ViewModel
    open func process(events: ViewModel.Events) { }
    
    ///Need to call super.attachNewSubscriptions() before implementing logic
    open func attachNewSubscriptions() {
        self.cancelSubsribtions()
    }
    
    // MARK: - Private Functions
    
    private func cancelSubsribtions() {
        self.cancellable.forEach {
            $0.cancel()
        }
    }
}
