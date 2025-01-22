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
        self.viewModel?.fetchBPIRate()
        self.viewModel?.fetchTransactions()
        self.viewModel?.fetchBalance()
    }
    
    // MARK: BaseViewController
    
    override func process(events: ViewModel.Events) {
        super.process(events: events)
        switch events {
        case .bpiRateUpdated(let model):
            self.updateBPI(with: model)
        case .transactionsUpdated(let transactions): break
        case .balanceUpdated(let model):
            self.updateBalance(with: model)
        case .updateFailed:
            self.view.backgroundColor = .red
        }
    }
}

extension MainViewController {
    
    private func updateBPI(with model: BPIRatePresentationModel) {
        let rate = model.rate.description
        let currency = model.currencyCode.description
        let text = rate + " " + currency
        self.uiView?.setBpiLabel(text: text)
    }
    
    private func updateBalance(with model: BalancePresentationModel) {
        self.uiView?.setBalanceLabel(text: model.balance.description)
    }
}
