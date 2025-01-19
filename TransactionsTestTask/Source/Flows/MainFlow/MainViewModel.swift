//
//  MainViewModel.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import Combine

// MARK: Types

enum MainViewModelEvents { }

// MARK: Protocol

protocol MainViewModel: Eventable where Events == MainViewModelEvents { }

// MARK: MainViewModel

final class MainViewModelImpl: MainViewModel {
    
    // MARK: Internal properties
    
    var events: AnyPublisher<MainViewModelEvents, Never>? {
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: Private properties
    
    private var subject = PassthroughSubject<MainViewModelEvents, Never>()
}
