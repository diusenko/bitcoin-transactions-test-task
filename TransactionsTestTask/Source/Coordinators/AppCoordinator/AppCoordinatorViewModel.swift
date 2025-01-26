//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import Combine

// MARK: - Types

enum AppCoordinatorEvents {
    case showRisingBalance
}

// MARK: - Protocol

protocol AppCoordinatorViewModel: Eventable where Events == AppCoordinatorEvents {
    func change(balance: Float)
}

// MARK: - MainViewModel

final class AppCoordinatorViewModelImpl: AppCoordinatorViewModel {
    
    // MARK: - Internal Properties
    
    var events: AnyPublisher<AppCoordinatorEvents, Never>? {
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private var mainViewModel: (any MainViewModel)?
    private var subject = PassthroughSubject<AppCoordinatorEvents, Never>()
    
    init(mainViewModel: any MainViewModel) {
        self.mainViewModel = mainViewModel
    }
    
    func change(balance: Float) {
        self.mainViewModel?.change(balance: balance)
    }
    
}
