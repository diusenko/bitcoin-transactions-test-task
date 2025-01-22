//
//  AccountBalanceService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import Foundation
import Combine

// MARK: - Crypto Price Service Protocol

protocol AccountBalanceService {
    
    func fetchBalance() -> AnyPublisher<AccountBalance, Error>
}

// MARK: - Crypto Price Service Implementation

final class AccountBalanceServiceImpl: AccountBalanceService {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService
    
    // MARK: - Init
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Functions
    
    func fetchBalance() -> AnyPublisher<AccountBalance, Error> {
        let endPoint = APIEndpoint.accountBalanceEndpoint()
        return self.networkService.request(endPoint, method: .get)
    }
}
