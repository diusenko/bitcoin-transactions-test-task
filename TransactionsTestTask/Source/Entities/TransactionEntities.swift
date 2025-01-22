import Foundation

struct TransactionsByDate: Codable {
    let date: Date
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let time: Date
    let bitcoins: Int
    let transactionType: TransactionDetail
}

enum TransactionType: String, Codable {
    case expense
    case income
}

struct TransactionDetail: Codable {
    let type: TransactionType
    let category: String?
}
