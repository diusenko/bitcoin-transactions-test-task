//
//  MainViewModel.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import Foundation
import Combine

// MARK: - Types

/// Need to create Interactor for redeiving models and VM will be only prepear titles for VC
enum MainViewModelEvents {
    case bpiRateUpdated(BPIRatePresentationModel)
    case transactionsUpdated([TransactionDetail])
    case balanceUpdated(BalancePresentationModel)
    case updateFailed
}

// MARK: - Protocol

protocol MainViewModel: ViewModel where Events == MainViewModelEvents {
    func fetchBPIRate()
    func fetchTransactions()
    func fetchBalance()
}

// MARK: - MainViewModel

final class MainViewModelImpl: MainViewModel {
    
    // MARK: - Computed Properties
    
    var events: AnyPublisher<MainViewModelEvents, Never>? {
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    
    private var subject = PassthroughSubject<MainViewModelEvents, Never>()
    private var bpiRateFetcherService: BPIRateFetcherService
    private var transactionService: TransactionsService
    private var accountBalanceService: AccountBalanceService
    private var cancelable: Set<AnyCancellable> = []
    
    private var transactions: [TransactionDetail] = []
    private var accountBalance: AccountBalance?
    private var currentPrice: BPIRate?
    
    // MARK: - Deinit
    
    deinit {
        self.cancelable.forEach {
            $0.cancel()
        }
    }
    
    // MARK: - Init
    
    init(with bpiRateFetcherService: BPIRateFetcherService,
         and transactionService: TransactionsService,
         and accountBalanceService: AccountBalanceService
    ) {
        self.bpiRateFetcherService = bpiRateFetcherService
        self.transactionService = transactionService
        self.accountBalanceService = accountBalanceService
    }
    
    // MARK: - Final Functions
    
    func fetchBPIRate () {
        self.bpiRateFetcherService.fetchBPIRate().sink { [weak self] completion in
            if case .failure(_) = completion {
                self?.sendEventOnMain(.updateFailed)
            }
        } receiveValue: { [weak self] model in
            self?.sendUpdatedBPIRateEvent(with: model)
        }.store(in: &self.cancelable)
    }
    
    func fetchTransactions() {
        self.transactionService.fetchTransactions().sink { error in
            print(error)
        } receiveValue: { model in
            print(model)
        }.store(in: &self.cancelable)
    }
    
    func fetchBalance() {
        self.accountBalanceService.fetchBalance().sink { error in
            print(error)
        } receiveValue: { [weak self] model in
            self?.sendBalanceUpdatedEvent(with: model)
        }.store(in: &self.cancelable)
    }
    
    // MARK: Private Functions
    
    private func sendUpdatedBPIRateEvent(with model: BPIRate) {
        let rate = model.bpi.USD.rate
        let code = model.bpi.USD.code
        let presentationModel = BPIRatePresentationModel(rate: rate,
                                                         currencyCode: code)
        
        self.sendEventOnMain(.bpiRateUpdated(presentationModel))
    }
    
    private func sendBalanceUpdatedEvent(with model: AccountBalance) {
        let presentationModel = BalancePresentationModel(balance: model.balance)
        
        self.sendEventOnMain(.balanceUpdated(presentationModel))
    }
    
    private func sendEventOnMain(_ event: MainViewModelEvents?) {
        if let event = event {
            DispatchQueue.main.async {
                self.subject.send(event)
            }
        }
    }
    
    private func cancelSubscriprions() {
        self.cancelable.forEach { $0.cancel() }
    }
}
