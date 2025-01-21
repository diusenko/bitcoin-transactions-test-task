//
//  NetworkService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

import Foundation
import Combine

// MARK: - HTTP Methods

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - Network Service Protocol

protocol NetworkService {
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, method: HTTPMethod) -> AnyPublisher<T, Error>
}

// MARK: - Network Service Implementation

final class NetworkServiceImpl: NetworkService {
    
    private let errorProcessor: ErrorProcessor
    private let responseProcessor: ResponseProcessor

    // MARK: - Init
    
    init(errorProcessor: ErrorProcessor, responseProcessor: ResponseProcessor) {
        self.errorProcessor = errorProcessor
        self.responseProcessor = responseProcessor
    }
    
    // MARK: - Public Functions
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, method: HTTPMethod) -> AnyPublisher<T, Error> {
        let publisher: AnyPublisher<T, Error>
        if let url = endpoint.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            publisher = self.createURLSessionPublisher(with: request)
        } else {
            let error = self.errorProcessor.converted(error: URLError(.badURL))
            publisher = Fail(error: error).eraseToAnyPublisher()
        }
        return publisher
    }
    
    // MARK: - Private Functions
    
    private func createURLSessionPublisher<T: Decodable>(with request: URLRequest) -> AnyPublisher<T, Error> {
        let errorMessage = LocalizationConstants.NetworkErrors.unexpectedError
        let unexpectedError = NetworkErrors.unexpected(error: errorMessage)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let self = self else {
                    throw unexpectedError
                }
                return try self.responseProcessor.process(response: response,
                                                          data: data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { [weak self] error -> Error in
                self?.errorProcessor.converted(error: error) ?? unexpectedError
            }
            .eraseToAnyPublisher()
    }
}
