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

    // MARK: Init
    
    init(errorConverter: ErrorConverter) {
        self.errorConverter = errorConverter
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
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let self = self else {
                    throw NetworkErrors.unexpected(error: "Self was deallocated")
                }
                // Ensure the response is processed successfully
                return try self.process(response: response, with: data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { [weak self] error -> Error in
                guard let self = self else {
                    return NetworkErrors.unexpected(error: "Self was deallocated")
                }
                return self.errorConverter.converted(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    // TODO: - Create ResponceProcessor
    /// For my opinion needs to create some entity for injection and substitution Response
    private func process(response: URLResponse, with data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.responseUnsuccessful
        }
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200...299:
            return data
        case 400...499:
            throw NetworkErrors.requestFailed(statusCode: statusCode)
        case 500...599:
            throw NetworkErrors.serverError(statusCode: statusCode)
        default:
            throw NetworkErrors.unexpected(error: "HTTP Status Code: \(statusCode)")
        }
    }
}
