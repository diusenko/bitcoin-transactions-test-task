//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

// MARK: - MainViewControllerImpl

final class MainViewController<ViewModel: MainViewModel,
                               View: MainView>:
                               BaseViewController<ViewModel, View> {
    
    // MARK: - Private Properties
    
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.updateCurrentPriceModel()
        self.viewModel?.fetchTransactions()
        self.viewModel?.fetchBalance()
    }
    
    // MARK: BaseViewController
    
    override func process(events: ViewModel.Events) {
        super.process(events: events)
        switch events {
        case .currentPriceModelUpdated(let currentPrice): break
        case .transactionsUpdated(let transactions): break
        case .
        case .updateFailed:
            self.view.backgroundColor = .red
        }
    }
}
