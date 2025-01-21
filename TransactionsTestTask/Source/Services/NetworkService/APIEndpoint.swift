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
    }

    enum Hosts: String {
        case coindeskHost = "api.coindesk.com"
    }
    
    enum Endpoints: String {
        case currentPrice = "/v1/bpi/currentprice.json"
    }
    
    let scheme: Schemes
    let host: Hosts
    let endPoint: Endpoints
    var queryItems: [URLQueryItem]?

    var url: URL? {
        var components = URLComponents()
        components.scheme = self.scheme.rawValue
        components.host = self.host.rawValue
        components.path = self.endPoint.rawValue
        components.queryItems = self.queryItems
        return components.url
    }
    
    static func currentPriceEndpoint() -> APIEndpoint {
        return APIEndpoint(scheme: APIEndpoint.Schemes.scheme,
                           host: APIEndpoint.Hosts.coindeskHost,
                           endPoint: APIEndpoint.Endpoints.currentPrice)
    }
}
