//
//  ResponseProcessor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 21.01.2025.
//

import Foundation

// MARK: - Response Processor Protocol

protocol ResponseProcessor {
    
    func process(response: URLResponse, data: Data) throws -> Data
}

// MARK: - Response Processor Implementation

final class ResponseProcessorImpl: ResponseProcessor {
    
    func process(response: URLResponse, data: Data) throws -> Data {
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            switch statusCode {
            case 200...299:
                return data
            case 400...499:
                throw NetworkErrors.requestFailed(statusCode: statusCode)
            case 500...599:
                throw NetworkErrors.serverError(statusCode: statusCode)
            default:
                let errorMessage = LocalizationConstants.NetworkErrors.unexpectedError
                throw NetworkErrors.unexpected(error: errorMessage + ": \(statusCode)")
            }
        } else {
            return data
        }

    }
}
