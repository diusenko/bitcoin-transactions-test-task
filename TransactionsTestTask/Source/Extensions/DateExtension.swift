//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import Foundation

extension Date {
    
    static func date(from dateInterval: TimeInterval,
                     and timeInterval: TimeInterval) -> Date {
        let combinedInterval = dateInterval + timeInterval
        
        return Date(timeIntervalSince1970: combinedInterval)
    }
}
