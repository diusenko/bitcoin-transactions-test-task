//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 18.01.2025.
//

import UIKit
import Combine

// MARK: - MainViewControllerImpl

final class MainViewController<ViewModel: MainViewModel,
                               View: MainView>:
                               BaseViewController<ViewModel, View> {
    
    // MARK: - Private Properties
    
    var cancellable: Set<AnyCancellable> = []
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCurrentPrice()
    }
        
    // MARK: Internal Function
    
    func getCurrentPrice() {
        self.uiView?.showIndicator()
        self.viewModel?.updateCurrentPriceModel()
    }
    
    // MARK: BaseViewController
    
    override func process(events: ViewModel.Events) {
        super.process(events: events)
        switch events {
        case .currentPriceModelUpdated(_): break
        case .updateFailed:
            self.view.backgroundColor = .red
        }
    }
}
