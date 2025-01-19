//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import UIKit
import Combine

class BaseViewController<ViewModel: Eventable>: UIViewController, Attachable {
    
    // MARK: Deinit
    
    /// Canceling subscription.
    deinit {
        self.cancelSubsribtions()
    }
    
    // MARK: Internal properties
    
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: Internal functions
    
    final func attach(with viewModel: ViewModel) {
        self.attachNewSubscriptions()
        viewModel.events?.sink { [weak self] events in
            self?.process(events: events)
        }.store(in: &self.cancellable)
    }
    
    // MARK: Open functions
    
    /// Override this method for processing events that was produced by ViewModel
    open func process(events: ViewModel.Events) { }
    ///Need to call super.attachNewSubscriptions() before implementing logic
    open func attachNewSubscriptions() {
        self.cancelSubsribtions()
    }
    
    // MARK: Private functions
    
    private func cancelSubsribtions() {
        self.cancellable.forEach {
            $0.cancel()
        }
    }
}
