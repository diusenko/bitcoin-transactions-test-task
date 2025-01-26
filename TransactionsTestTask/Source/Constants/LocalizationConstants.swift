//
//  Constants.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 20.01.2025.
//

enum LocalizationConstants {
        
    enum NetworkErrors {
        static let invalidURL = "Invalid URL"
        static let requestFailed = "Request Failed with error: "
        static let invalidData = "Invalid Data"
        static let jsonParsingFailure = "JSON Parsing Failure"
        static let responseUnsuccessful = "Response Unsuccessful"
        static let unexpectedError = "Unexpected network error"
        static let notConnectedToInternet = "Internet connection problem"
        static let statusCode = "HTTP Status Code"
    }
    
    enum MainViewConstants {
        static let addTransaction = "Add Transaction"
    }
    
    enum Alert {
        static let title = "Fill up the account"
        static let messageTitle = "How much you want add"
        static let placeholder = "Enter bitcoins here"
        static let okButtonTitle = "Ok"
        static let cancelButtonTitle = "Cancel"
    }
}
