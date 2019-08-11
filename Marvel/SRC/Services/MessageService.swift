//
//  MessageService.swift
//  Marvel
//
//  Created by Volodymyr on 8/11/19.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import Foundation

class MessageService {
    
    // MARK: - Singleton
    static let instance = MessageService()
    
    
    // MARK: - Initialization
    private init() { }
    
    
    // MARK: - Public methods
    
    func randomMessage(for author: AuthorChat, characterId: Int) -> MessageChat {
        let message = newMessage(with: randomAnswer(), for: author, characterId: characterId)
        
        return message
    }
    
    
        func newMessage(with content: String, for author: AuthorChat, characterId: Int) -> MessageChat {
        let message = MessageChat()
        message.author = author
        message.id = String(Int.random(in: 1..<50000))
        message.characterId = characterId
        message.content = content
        message.ts = Int(Date().timeIntervalSince1970)
        
        return message
    }
    
    
    // MARK: - Private methods
    
   private func randomAnswer() -> String {
        let ansrwers = ["Hi.. 😀", "Bye! :) 😛", "How are you ?", "Really ? 🤪", "I am busy"]
        
        return ansrwers.randomElement().default
    }
}
