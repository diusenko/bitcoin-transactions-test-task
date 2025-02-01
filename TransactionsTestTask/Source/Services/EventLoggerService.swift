//
//  EventLoggerService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 23.01.2025.
//

import Combine

protocol EventLoggerService {
    
    func addSubscription<T: Publisher>(publisher: T, with identifier: String) where T.Output: CustomStringConvertible
}

/// Object that subscribes to publishers, logs their output, and manages subscriptions.
final class EventLoggerServiceImpl: EventLoggerService {

    // MARK: - Private Properties

    private var cancellables: Set<AnyCancellable> = []
    private let analyticsService: AnalyticsService

    // MARK: - Deinitializer

    deinit {
        self.cancelAll()
        let id = "\(type(of: self))"
        let text = "PublisherLogger deinitialized and all subscriptions cancelled."
        analyticsService.trackEvent(type: .deinited, parameters: [id : text])
    }
    
    // MARK: - Initializer

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

    // MARK: - Final Functions

    func addSubscription<T: Publisher>(publisher: T, with identifier: String) {
        self.log(publisher: publisher, with: identifier)
    }

    // MARK: - Private Functions

    private func log<T: Publisher>(publisher: T, with identifier: String) {
        publisher
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.analyticsService.trackEvent(type: .custom,
                                                          parameters: [identifier : "finished"])
                    case .failure(let error):
                        let params = "Publisher failed with error: \(error)."
                        self?.analyticsService.trackEvent(type: .error,
                                                          parameters: [identifier : params])
                    }
                },
                receiveValue: { [weak self] value in
                    let params = [ identifier : "\(value)" ]
                    self?.analyticsService.trackEvent(type: .updated,
                                                      parameters: params)
                }
            )
            .store(in: &cancellables)
    }
    
    /// Cancels all active subscriptions.
    private func cancelAll() {
        cancellables.removeAll()
    }
}
