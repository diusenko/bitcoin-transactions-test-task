//
//  AnalyticsEvent.swift
//  TransactionsTestTask
//
//

import Foundation

enum AnalyticsEventType: String {
    case updated
    case custom
    case error
    case deinited
}

struct AnalyticsEvent {
    let type: AnalyticsEventType
    let parameters: [String: String]
    let date: Date
}
