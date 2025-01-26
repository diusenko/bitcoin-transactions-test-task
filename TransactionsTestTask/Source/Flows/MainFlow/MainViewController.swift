//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

enum MainViewControllerEvents {
    case showRefilBalance
    case showTransaction
}

// MARK: - MainViewControllerImpl

final class MainViewController<ViewModel: MainViewModel,
                               View: MainView>:
                               BaseViewController<ViewModel, View>, Eventable {
    
    var events: AnyPublisher<MainViewControllerEvents, Never>? {
        self.subject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    
    private var subject = PassthroughSubject<Events, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.fetchBPIRate()
        self.viewModel?.fetchTransactions()
        self.viewModel?.fetchBalance()
        self.uiView?.addBitcoinsButtonTapHandler = { [weak self] in
            self?.subject.send(.showRefilBalance)
        }
        self.uiView?.addTransactionButtonHandler = { [weak self] in
            self?.subject.send(.showTransaction)
        }
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
