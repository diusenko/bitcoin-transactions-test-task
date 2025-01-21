import Foundation
import Combine

// TODO: - Change NetworkErrors enum to ErrorConverter
/// Needs to create some entity for injection and substitution Response

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

// MARK: - Default Network Service Implementation
final class NetworkServiceImpl: NetworkService {
    
    private let errorConverter: ErrorConverter
    private let responseProcessor: ResponseProcessor

    // MARK: Init
    
    init(errorConverter: ErrorConverter, responseProcessor: ResponseProcessor) {
        self.errorConverter = errorConverter
        self.responseProcessor = responseProcessor
    }
    
    // MARK: Inernal functions
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, method: HTTPMethod) -> AnyPublisher<T, Error> {
        let publisher: AnyPublisher<T, Error>
        if let url = endpoint.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            publisher = self.createURLSessionPublisher(with: request)
        } else {
            let error = self.errorConverter.converted(error: URLError(.badURL))
            publisher = Fail(error: error).eraseToAnyPublisher()
        }
        
        return publisher
    }
    
    // MARK: Private functions
    
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
                self?.errorConverter.converted(error: error) ?? unexpectedError
            }
            .eraseToAnyPublisher()
    }
}
