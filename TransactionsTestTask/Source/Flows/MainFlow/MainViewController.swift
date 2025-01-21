//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

// MARK: - MainViewControllerImpl

final class MainViewController<ViewModel: MainViewModel>: BaseViewController<ViewModel> {
    
    // MARK: - Private Properties
    
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .cyan
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentPrice()
    }
    
    // MARK: Internal Function
    
    func getCurrentPrice() {
        self.viewModel?.updateCurrentPriceModel()
    }
    
    // MARK: BaseViewController
    
    override func process(events: ViewModel.Events) {
        switch events {
        case .currentPriceModelUpdated(let model):
            print(model)
        case .updateFailed:
            self.view.backgroundColor = .red
        }
    }
}
