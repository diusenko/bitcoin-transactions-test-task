//
//  Attouchable.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 19.01.2025.
//

import UIKit

/// This protocol needed for ViewControllers which can attach ViewModels.
/// Func "attach" is for attaching ViewModels..
protocol ViewModelAttachable where Self: UIViewController {
    associatedtype ViewModel: Eventable
    func attach(with viewModel: ViewModel)
}

protocol ViewAttachable where Self: UIViewController {
    associatedtype View: IndicatorDisplayable
    func attach(view: View)
}

protocol Attachable: ViewModelAttachable,ViewAttachable { }
