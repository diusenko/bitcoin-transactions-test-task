//
//  Eventable.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import Combine

/// This protocol needed for objects which can produce events.
/// Property "events" for sinking listeners on events.
protocol Eventable: AnyObject {
    associatedtype Events
    var events: AnyPublisher<Events, Never>? { get }
}
