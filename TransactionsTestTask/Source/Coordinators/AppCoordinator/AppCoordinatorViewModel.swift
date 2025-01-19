//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import Combine

// MARK: Types

enum AppCoordinatorEvents { }

// MARK: Protocol

protocol AppCoordinatorViewModel: Eventable where Events == AppCoordinatorEvents { }

// MARK: MainViewModel

final class AppCoordinatorViewModelImpl: AppCoordinatorViewModel {
    
    // MARK: Internal properties
    
    var events: AnyPublisher<AppCoordinatorEvents, Never>? {
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: Private properties
    
    private var subject = PassthroughSubject<AppCoordinatorEvents, Never>()
}
