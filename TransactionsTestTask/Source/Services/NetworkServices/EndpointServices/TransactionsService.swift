//
//  TransactionsService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import Foundation
import Combine

// MARK: - Crypto Price Service Protocol

protocol TransactionsService {
    
    func fetchTransactions() -> AnyPublisher<[TransactionsByDate], Error>
}

// MARK: - Crypto Price Service Implementation

final class TransactionsServiceImpl: TransactionsService {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService
    
    // MARK: - Init
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Functions
    
    
    func fetchTransactions() -> AnyPublisher<[TransactionsByDate], any Error> {
        let endPoint = APIEndpoint.transactionsEndpoint()
        return networkService.request(endPoint, method: .get)
    }
}
