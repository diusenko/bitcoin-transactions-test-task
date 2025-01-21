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
        super.viewDidLoad()
        self.getCurrentPrice()
    }
    
    override func loadView() {
        self.view = MainView()
    }
    
    // MARK: Internal Function
    
    func getCurrentPrice() {
        self.viewModel?.updateCurrentPriceModel()
    }
    
    // MARK: BaseViewController
    
    override func process(events: ViewModel.Events) {
        switch events {
        case .currentPriceModelUpdated(let model): break
        case .updateFailed:
            self.view.backgroundColor = .red
        }
    }
}
