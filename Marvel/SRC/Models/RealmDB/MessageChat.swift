//
//  Message.swift
//  Marvel
//
//  Created by Volodymyr
//  Copyright © 2019 Ukraine. All rights reserved.
//

import RealmSwift

enum AuthorChat: String {
    case player 
    case character
}

class MessageChat: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var characterId: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var ts: Int = 0
    @objc private dynamic var _author: String = AuthorChat.character.rawValue
    var author: AuthorChat {
        get { return AuthorChat(rawValue: _author)! }
        set { _author = newValue.rawValue }
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

extension MessageChat {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(ts))
    }
}
