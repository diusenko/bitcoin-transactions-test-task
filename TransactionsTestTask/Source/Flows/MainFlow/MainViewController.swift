//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

// MARK: MainViewControllerImpl

final class MainViewController<ViewModel: MainViewModel>: BaseViewController<ViewModel> {
    
    // MARK: Private properties
    
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .cyan
        super.viewDidLoad()
    }
}
