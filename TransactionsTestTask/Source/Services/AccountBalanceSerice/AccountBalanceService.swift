//
//  AccountBalanceService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 31.01.2025.
//

import Combine

enum AccountBalanceServiceEvents {
    case startUpdating
    case balanceUpdated(Float)
    case updatingFailed(Error)
}

protocol AccountBalanceService: Eventable where Events == AccountBalanceServiceEvents {
    func emitFetchingBalance()
    func addToBalance(value: Float)
}

class AccountBalanceServiceImpl: AccountBalanceService {
    
    var events: AnyPublisher<AccountBalanceServiceEvents, Never>? {
        return _events.eraseToAnyPublisher()
    }
    
    private var balanceFetchService: AccountBalanceFetchService
    private var currentBalance: Float = 0.0
    
    private var _events = PassthroughSubject<AccountBalanceServiceEvents, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(balanceFetchService: AccountBalanceFetchService) {
        self.balanceFetchService = balanceFetchService
    }
    
    func emitFetchingBalance() {
        self.fetchBalance()
    }
    
    func addToBalance(value: Float) {
        self.update(balance: value)
    }
}

// MARK: - Extension

extension AccountBalanceServiceImpl {
    
    private func fetchBalance() {
        self._events.send(.startUpdating)
        self.balanceFetchService
            .fetchBalance()
            .sink
        { [weak self] completion in
            if case .failure(let error) = completion {
                self?._events.send(.updatingFailed(error))
            }
        } receiveValue: { [weak self] model in
            self?.update(balance: model.balance)
        }.store(in: &self.cancellables)
    }
    
    private func update(balance: Float) {
        self.currentBalance += balance
        self._events.send(.balanceUpdated(self.currentBalance))
    }
}
