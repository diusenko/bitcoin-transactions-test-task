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

struct AnalyticsEvent: CustomStringConvertible {
    let type: AnalyticsEventType
    let parameters: [String: String]
    let date: Date
    
    var description: String {
        return type.rawValue
        + "\n"
        + date.debugDescription
        + "\n"
        + parameters.debugDescription
    }
}
