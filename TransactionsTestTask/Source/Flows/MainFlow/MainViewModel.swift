//
//  MainViewModel.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import Foundation
import Combine

// MARK: - Types

enum MainViewModelEvents {
    case currentPriceModelUpdated(Bitcoin)
    case transactionsUpdated([TransactionDetail])
    case balanceUpdated(AccountBalance)
    case updateFailed
}

// MARK: - Protocol

protocol MainViewModel: ViewModel where Events == MainViewModelEvents {
    func updateCurrentPriceModel()
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
    private var currentPriceService: CurrentPriceService
    private var transactionService: TransactionsService
    private var accountBalanceService: AccountBalanceService
    private var cancelable: Set<AnyCancellable> = []
    
    // MARK: - Deinit
    
    deinit {
        self.cancelable.forEach {
            $0.cancel()
        }
    }
    
    // MARK: - Init
    
    init(with currentPriceService: CurrentPriceService,
         and transactionService: TransactionsService,
         and accountBalanceService: AccountBalanceService
    ) {
        self.currentPriceService = currentPriceService
        self.transactionService = transactionService
        self.accountBalanceService = accountBalanceService
    }
    
    // MARK: - Final Functions
    
    func updateCurrentPriceModel() {
        self.currentPriceService.fetchCurrentPrice().sink { [weak self] completion in
            if case .failure(_) = completion {
                self?.sendEventOnMain(.updateFailed)
            }
            self?.cancelSubscriprions()
        } receiveValue: { [weak self] model in
            self?.sendEventOnMain(.currentPriceModelUpdated(model))
        }.store(in: &self.cancelable)
    }
    
    func fetchTransactions() {
        self.transactionService.fetchTransactions().sink { error in
            print(error)
        } receiveValue: { model in
            print(model)
        }.store(in: &cancelable)
    }
    
    func fetchBalance() {
        self.accountBalanceService.fetchBalance().sink { error in
            print(error)
        } receiveValue: { model in
            print(model)
        }.store(in: &cancelable)
    }
    
    // MARK: Private Functions
    
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
