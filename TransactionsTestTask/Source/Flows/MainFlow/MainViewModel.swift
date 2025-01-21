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
    case updateFailed
}

// MARK: - Protocol

protocol MainViewModel: ViewModel where Events == MainViewModelEvents {
    func updateCurrentPriceModel()
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
    private var cancelable: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(with currentPriceService: CurrentPriceService) {
        self.currentPriceService = currentPriceService
    }
    
    // MARK: - Final Functions
    
    func updateCurrentPriceModel() {
        self.currentPriceService.fetchCurrentPrice().sink { [weak self] completion in
            if case .failure(let error) = completion {
                print(error)
                self?.sendEventOnMain(.updateFailed)
            }
            self?.cancelSubscriprions()
        } receiveValue: { [weak self] model in
            self?.sendEventOnMain(.currentPriceModelUpdated(model))
        }.store(in: &self.cancelable)
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
