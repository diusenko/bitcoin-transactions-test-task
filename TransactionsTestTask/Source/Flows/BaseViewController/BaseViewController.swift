//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import UIKit
import Combine

class BaseViewController<ViewModel: Eventable,
                         View: BaseView>: UIViewController, ViewController {
    
    // MARK: - Deinit
    
    /// Canceling subscription.
    deinit {
        self.cancelSubsribtions()
    }
    
    // MARK: - Private Properties
    
    private(set) var viewModel: ViewModel?
    private(set) var uiView: View?
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - ViewController Lifecycle
    
    override func loadView() {
        self.view = self.uiView
    }
    
    // MARK: - Open Functions
    
    /// Override this method for processing events that was produced by ViewModel
    /// When method will be overrided calling super.process is required
    open func process(events: ViewModel.Events) {
        self.uiView?.hideIndicator()
    }
    
    /// Need to call super.attachNewSubscriptions() before implementing logic
    /// When method will be overrided calling super.process is required
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

// MARK: Attachable

extension BaseViewController {
    
    final func attach(with viewModel: ViewModel) {
        self.viewModel = viewModel
        self.attachNewSubscriptions()
        viewModel.events?.sink { [weak self] events in
            self?.process(events: events)
        }.store(in: &self.cancellable)
    }
    
    /// Call methods for updating ViewModel  events after only after loadView.
    /// Because View can not be assigned to View Controller
    final func attach(view: View) {
        self.uiView = view
    }
}
