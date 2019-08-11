//
//  UITableView+Extensions.swift
//
//  Created by Volodymyr.
//  Copyright © 2019 java. All rights reserved.
//

import UIKit
import Foundation

extension UITableView {
    
    func reusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let reuseIdentifier = String(describing: type)
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to find cell with reuseIdentifier \"\(reuseIdentifier)\"")
        }
        
        return cell
    }
    
    func reusableCell<Result: UITableViewCell>(
        _ type: Result.Type,
        for indexPath: IndexPath,
        configure: (Result) -> Void
        )
        -> Result {
            let identifier = String(describing: type)
            
            let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            (cell as? Result).map(configure)
            
            guard let resultCell = cell as? Result else {
                fatalError("\(type.description()) - Identifire doesnt set to tableView")
            }
            
            return resultCell
    }
    
    // Registering cell from nib for its self class
    func register(cellClass: AnyClass) {
        self.register(.nib(withClass: cellClass), forCellReuseIdentifier: String(describing: cellClass.self))
    }
    
    // Registering cell from nib for its self class
    func register(cellHeaderClass: AnyClass) {
        self.register(.nib(withClass: cellHeaderClass),
                      forHeaderFooterViewReuseIdentifier: String(describing: cellHeaderClass.self))
    }
    
    func updateTableView(with result: () -> ()) {
        self.beginUpdates()
        result()
        self.endUpdates()
    }
}

extension UITableView {
    
    // AnimationOptions
    func reloadData(with animation: UITableView.AnimationOptions, duration: Double = 0.3) {
        UIView.transition(with: self, duration: duration,
                          options: animation, animations: {
                            self.reloadData()
        }, completion: nil)
    }
    
    func scrollToLastRow() {
        guard numberOfSections > 0 else { return }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfRows(inSection: lastSection) > 0 else { return }
        
        let lastRowIndexPath = IndexPath(row: numberOfRows(inSection: lastSection) - 1,
                                         section: lastSection)
        DispatchQueue.main.async {
            // UIView.animate(withDuration: 0.5, animations: {
            self.scrollToRow(at: lastRowIndexPath, at: .bottom, animated: true)
            //  })
        }
    }
    
    func scrollToLastRow(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.scrollToLastRow()
        }
    }
}
