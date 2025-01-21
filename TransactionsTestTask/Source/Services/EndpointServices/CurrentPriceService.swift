//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

import Combine

// MARK: - Crypto Price Service Protocol

protocol CurrentPriceService {
    
    func fetchCurrentPrice() -> AnyPublisher<Bitcoin, Error>
}

// MARK: - Crypto Price Service Implementation

final class CurrentPriceServiceImpl: CurrentPriceService {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService
    
    // MARK: - Init
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Functions
    
    func fetchCurrentPrice() -> AnyPublisher<Bitcoin, Error> {
        let endPoint = APIEndpoint.currentPriceEndpoint()
        
        return networkService.request(endPoint, method: .get)
    }
}
