//
//  UIAlertControllerExtension.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 26.01.2025.
//

import UIKit

extension UIAlertController {
    
    func addOkTextFieldAction(with completion: @escaping (Float) -> ()) {
        let okAction = UIAlertAction(title: AlertConstants.okButtonTitle, style: .default) { _ in
            if let inputText = self.textFields?.first?.text {
                let balance = Float(inputText) ?? 0
                completion(balance)
            }
        }
        self.addAction(okAction)
    }
}
