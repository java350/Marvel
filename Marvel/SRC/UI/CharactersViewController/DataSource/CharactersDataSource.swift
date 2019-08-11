//
//  MainDataSource.swift
//  Marvel
//
//  Created by Volodymyr on 8/8/19.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import Foundation
import UIKit

class CharacterDataSource: NSObject {
    
    // MARK:  Properties
    var slectedBlock: ((IndexPath) -> ())?
    
    fileprivate var viewModel: CharactersViewModel
    
    
    // MARK: - Initializations
    init(_ table: UITableView?, viewModel: CharactersViewModel) {
        self.viewModel = viewModel
    }
    
    
    // MARK:  Public methods
    func configure(_ cell: CharacterCell, for indexPath: IndexPath) -> UITableViewCell  {
        if viewModel.isLoadingCell(for: indexPath) {
            cell.fill(with: .none)
        } else {
            cell.fill(with: viewModel.character(at: indexPath.row))
        }
        
        return cell
    }
}

extension CharacterDataSource: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.slectedBlock?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(CharacterCell.self, for: indexPath)
        
        return self.configure(cell, for: indexPath)
    }
    
}

