//
//  ErrorProcessor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

import Foundation

// MARK: - Error Processor Protocol

protocol ErrorProcessor {
    
    func converted(error: Error) -> Error
}

// MARK: - Error Processor Implementation

final class ErrorProcessorImpl: ErrorProcessor {
    
    func converted(error: Error) -> Error {
        var networkError: Error = error
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                networkError = NetworkErrors.notConnectedToInternet
            case .timedOut:
                networkError = NetworkErrors.timeOut
            case .badURL:
                networkError = NetworkErrors.invalidURL
            default:
                networkError = NetworkErrors.unexpected(error: ":\(urlError.localizedDescription)")
            }
        } else if error is DecodingError {
            networkError = NetworkErrors.jsonParsingFailure
        }
        return networkError
    }
}
