//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 23.01.2025.
//

import Combine

/// This Sevice needs to avoid error.
/// Error occurs appears because Swift 5.7 introduced the concept of existential types for protocols.
/// When using a protocol with associated types or Self requirements,
/// you can’t use the protocol directly as a type.
/// Instead, you must explicitly declare it as any BitcoinRateService.
/// However, even with any BitcoinRateService, you cannot use protocols with associatedtype directly as a variable type.
final class AnyBitcoinRateService: BitcoinRateService {
    
    // MARK: - Properties
    
    private let _startUpdating: () -> Void
    private let _events: AnyPublisher<BitcoinRateServiceEvents, Never>?
    
    var events: AnyPublisher<BitcoinRateServiceEvents, Never>? {
        return _events
    }
    
    // MARK: - Initializer
    
    init<T: BitcoinRateService>(_ service: T) where T.Events == BitcoinRateServiceEvents {
        self._startUpdating = { service.startUpdating() }
        self._events = service.events
    }
    
    // MARK: - Methods
    
    func startUpdating() {
        _startUpdating()
    }
}
