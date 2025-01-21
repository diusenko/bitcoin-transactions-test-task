//
//  BaseProtocols.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 21.01.2025.
//

import UIKit

protocol ViewModel: AnyObject, Eventable { }

protocol ViewController: UIViewController, Attachable {
    func process(events: ViewModel.Events)
    func attachNewSubscriptions()
}
