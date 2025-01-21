//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

import Foundation

enum NetworkErrors: LocalizedError {
    
    case invalidURL
    case invalidData
    case requestFailed(statusCode: Int)
    case serverError(statusCode: Int)
    case jsonParsingFailure
    case responseUnsuccessful
    case notConnectedToInternet
    case timeOut
    case unexpected(error: String? = "")
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return LocalizationConstants.NetworkErrors.invalidURL
        case .invalidData:
            return LocalizationConstants.NetworkErrors.invalidData
        case .requestFailed(let code):
            return LocalizationConstants.NetworkErrors.requestFailed + code.description
        case .jsonParsingFailure:
            return LocalizationConstants.NetworkErrors.jsonParsingFailure
        case .responseUnsuccessful:
            return LocalizationConstants.NetworkErrors.responseUnsuccessful
        case .notConnectedToInternet:
            return LocalizationConstants.NetworkErrors.notConnectedToInternet
        case .timeOut:
            return LocalizationConstants.NetworkErrors.responseUnsuccessful
        case .unexpected(let error):
            return LocalizationConstants.NetworkErrors.unexpectedError + (error ?? "")
        case .serverError(let code):
            return LocalizationConstants.NetworkErrors.requestFailed + code.description
        }
    }
}

// MARK: - Error Handling Protocol

protocol ErrorConverter {
    
    func converted(error: Error) -> Error
}

// MARK: - Default Error Handler Implementation

final class ErrorConverterService: ErrorConverter {
    
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
