//
//  BPICourceEntities.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

import Foundation

// MARK: - Current Price Model

struct BPIRate: Codable {
    let time: Time
    let chartName: String
    let bpi: BPI
}

// MARK: - Time Model

struct Time: Codable {
    let updated: String
    let updatedISO: String
    let updateduk: String
}

// MARK: - BPI Model

struct BPI: Codable {
    let USD: Currency
}

// MARK: - Currency Model

struct Currency: Codable {
    let code: String
    let symbol: String
    let rate: Float
    let description: String

    enum CodingKeys: String, CodingKey {
        case code, symbol, description
        case rate = "rate_float"
    }
}
