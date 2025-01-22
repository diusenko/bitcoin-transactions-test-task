//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

import Foundation

// MARK: - API Endpoints

struct APIEndpoint {
    
    enum Schemes: String {
        case scheme = "https"
        case file = "file"
    }

    enum Hosts: String {
        case coindeskHost = "api.coindesk.com"
        case empty = ""
    }
    
    enum Endpoints: String {
        case currentPrice = "/v1/bpi/currentprice.json"
        case transactionFile = "transactions"
    }
    
    let scheme: Schemes
    let host: Hosts
    let endPoint: Endpoints
    var queryItems: [URLQueryItem]?

    var url: URL? {
        var components = URLComponents()
        var path = self.endPoint.rawValue
        if self.endPoint == .transactionFile {
            path = self.pathToFile(for: self.endPoint) ?? ""
        }
        components.scheme = self.scheme.rawValue
        components.host = self.host.rawValue
        components.path = path
        components.queryItems = self.queryItems
        return components.url
    }
    
    static func currentPriceEndpoint() -> APIEndpoint {
        return APIEndpoint(scheme: .scheme,
                           host: .coindeskHost,
                           endPoint: .currentPrice)
    }
    
    static func transactionsEndpoint() -> APIEndpoint {
        return APIEndpoint(scheme: .file,
                           host: .empty,
                           endPoint: .transactionFile)
    }
    
    private func pathToFile(for endpoint: Endpoints) -> String? {
        let path = Bundle
            .main
            .path(forResource: endpoint.rawValue, ofType: "json")
        
        return path ?? ""
    }
}
