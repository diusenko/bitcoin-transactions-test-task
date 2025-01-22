//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Dmytro Usenko on 22.01.2025.
//

import UIKit

extension UITableView {
    
    /// Registers a cell type with the table view using the class name as the identifier.
    /// - Parameter cellType: The cell type to register.
    func register<Cell: UITableViewCell>(cellType: Cell.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }

    /// Dequeues a reusable cell of the specified type.
    /// - Parameter cellType: The cell type to dequeue.
    /// - Parameter indexPath: The index path for the cell.
    /// - Returns: A reusable cell of the specified type.
    func dequeueReusableCell<Cell: UITableViewCell>(for cellType: Cell.Type,
                                                    at indexPath: IndexPath) -> Cell {
        let identifier = String(describing: cellType)
        let cell = self.dequeueReusableCell(withIdentifier: identifier,
                                            for: indexPath) as? Cell
        return cell ?? Cell()
    }
}
