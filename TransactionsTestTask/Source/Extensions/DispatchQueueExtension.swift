//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 23.01.2025.
//

import Dispatch

extension DispatchQueue {
    
    static func customSerialQueue<T>(with type: T.Type ) -> DispatchQueue {
        let identifier = String(describing: type)
        
        return DispatchQueue(label: identifier)
    }
}
