//
//  ChatDataSource.swift
//
//  Created by Volodymyr on 7/17/19.
//  Copyright © 2019 DANUBIASOFT. All rights reserved.
//

import Foundation
import UIKit

extension ChatDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = viewModel.sections[indexPath.section].messages[indexPath.row]
        let cellType = message.author == .character
            ? CharacterMessageCell.self
            : PlayerMessageCell.self
        let cell = tableView.reusableCell(cellType, for: indexPath)

        return configure(cell, for: indexPath)
    }
}


class ChatDataSource: NSObject {
    
    // MARK: - Properties
    
    fileprivate var viewModel: ChatViewModel<ChatSection>
    
    
    // MARK: - Initializations
    
    init(_ table: UITableView?, viewModel: ChatViewModel<ChatSection>) {
        self.viewModel = viewModel
    }
    
    
    // MARK: - Public methods
    
    func configure(_ cell: FillableChatCell<MessageChat>, for indexPath: IndexPath) -> UITableViewCell {
        cell.fill(viewModel.sections[indexPath.section].messages[indexPath.row],
                  firstMessage: viewModel.isFirstMessage(at: indexPath),
                  avatarUrl: viewModel.character.thumbnail.fullImageUrl)
        
        return cell
    }
}
