//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation
import OSLog

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests
protocol AnalyticsService: AnyObject {
    func trackEvent(type: AnalyticsEventType,
                    parameters: [String: String])
    func getEventsFilteredBy(types: [AnalyticsEventType]?,
                             dateRange: ClosedRange<Date>?) -> [AnalyticsEvent]
}

final class AnalyticsServiceImpl {
    
    private var events: [AnalyticsEventType: [AnalyticsEvent]] = [:]
    private var logger = Logger()
    private let queue = DispatchQueue(label: "com.analytics.service", attributes: .concurrent)
    
    // MARK: - Init
    init() {}
}

extension AnalyticsServiceImpl: AnalyticsService {
    
    func trackEvent(type: AnalyticsEventType,
                    parameters: [String: String]
    ) {
        let event = AnalyticsEvent(
            type: type,
            parameters: parameters,
            date: .now
        )
        self.logger.debug("\(event.description)")
        self.queue.async(flags: .barrier) { [weak self] in
            self?.events[type, default: []].append(event)
        }
    }
    
    func getEventsFilteredBy(types: [AnalyticsEventType]?,
                             dateRange: ClosedRange<Date>?
    )
        -> [AnalyticsEvent]
    {
        self.queue.sync {
            let filteredEvents: [AnalyticsEvent]
            
            if let types = types, !types.isEmpty {
                filteredEvents = types.flatMap { self.events[$0, default: []] }
            } else {
                filteredEvents = self.events.values.flatMap { $0 }
            }
            
            return filteredEvents.filter { event in
                guard let range = dateRange else { return true }
                return range.contains(event.date)
            }
        }
    }
}
