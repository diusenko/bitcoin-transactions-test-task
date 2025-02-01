//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests

enum BitcoinRateServiceEvents {
    
    case bpiUpdated(BPIRate)
    case needsToSave(BPIRate)
    case updatingFailed(Error)
}

protocol BitcoinRateService: Eventable where Events == BitcoinRateServiceEvents {
    func startUpdating()
}

/// Do NOT write code at 2 a.m.
final class BitcoinRateServiceImpl: BitcoinRateService {
        
    var events: AnyPublisher<BitcoinRateServiceEvents, Never>? {
        return subject.eraseToAnyPublisher()
    }
    
    private let bpiRateFetcherService: BPIRateFetcherService
    private let timer: Timer
    private let customSerialQueue: DispatchQueue
    private var subject = PassthroughSubject<BitcoinRateServiceEvents, Never>()
    private var cancelableBpiRate: Set<AnyCancellable> = []
    private var currentBPIRate: BPIRate?
    
    // MARK: - Deinit
    
    deinit {
        self.stopUpdating()
    }
    
    // MARK: - Init
    
    init(rate: BPIRate? = nil,
         bpiRateFetcherService: BPIRateFetcherService,
         timer: Timer,
         queue: DispatchQueue = DispatchQueue.customSerialQueue(with: BitcoinRateServiceImpl.Type.self)
    ) {
        self.currentBPIRate = rate
        self.bpiRateFetcherService = bpiRateFetcherService
        self.timer = timer
        self.customSerialQueue = queue
    }
    
    // MARK: Final functions
    
    func startUpdating() {
        if !self.timer.isRunning {
            self.timer.startTimer(interval: 2,
                                  queue: self.customSerialQueue
            ) { [weak self] in
                self?.fetchBPIRate()
            }
        }
    }
}

/// Have two approach every update save bpi rate to DB
/// or
/// Save only when we can't get it from server. I prefer second one.
/// This approach has a problem.
/// In some cases we will have old rate.
/// But on another side first approch is also not a garatrie that data will be saved in DB.
extension BitcoinRateServiceImpl {
    
    // TODO: - Needs to check Reachability, or some button for trigerring startUpdating after receiving server error
    private func fetchBPIRate() {
        self.bpiRateFetcherService
            .fetchBPIRate()
            .sink
        { [weak self] completion in
            if case .failure(let error) = completion {
                self?.stopUpdating()
                self?.subject.send(.updatingFailed(error))
            }
        } receiveValue: { [weak self] model in
            self?.update(rate: model)
        }.store(in: &self.cancelableBpiRate)
    }
    
    private func update(rate: BPIRate) {
        if self.currentBPIRate == nil {
            self.subject.send(.needsToSave(rate))
        }
        self.currentBPIRate = rate
        self.subject.send(.bpiUpdated(rate))
    }
    
    private func stopUpdating() {
        self.cancelBpiRateSubscriptions()
        self.timer.stopTimer()
    }
    
    private func cancelBpiRateSubscriptions() {
        self.cancelableBpiRate.forEach { $0.cancel() }
    }
}
