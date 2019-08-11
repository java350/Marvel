//
//  ChatViewModel.swift
//
//  Created by Volodymyr.
//  Copyright © 2019 DoneIt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ChatViewModel<T: ChatSectionProtocol>: ViewModel {
    
    // MARK: - Properties
    
    var title: String? = "Chat"
    var character: Character
    let realm = try! Realm()
    var sections: [T] = []
    
    let onRandomAnswer = PublishSubject<MessageChat>()
    private let messageService = MessageService.instance
    private let realmManager = RealmManager.instance
    private let bag = DisposeBag()
    
    
    // MARK: - Initializations
    
    init(character: Character) {
        self.character = character
    }
    
    
    // MARK: - Public methods
    
    func dataSource(with tableView: UITableView?) -> ChatDataSource {
        return ChatDataSource(tableView, viewModel: cast(self)!)
    }
    
    func addSection(_ section: T) {
        self.sections.append(section)
    }
    
    func addMessage(_ message: MessageChat) {
        let lastSection = self.sections.last
        if lastSection?.date.startOfDay == message.date.startOfDay {
            lastSection?.addMessage(message)
        } else {
            let titleDate = formatDate(message.date)
            let section = ChatSection(title: titleDate, messages: [message])
            cast(section).map(addSection)
        }
    }
    
    func isFirstMessage(at indexPath: IndexPath) -> Bool {
        let message = sections[indexPath.section].messages[indexPath.row]
        var result = indexPath.row == 0 ? true : false
        if message.author == .character && indexPath.row > 0 {
            let previosMessage = sections[indexPath.section].messages[indexPath.row - 1]
            result = previosMessage.author == .player
        }
        
        return result
    }
    
    func sendMessage(text: String, completion: @escaping (MessageChat)->()) {
        let messageToCharacter = messageService.newMessage(with: text,
                                                                for: .player,
                                                                characterId: self.character.id.default)
        realmManager.add(object: messageToCharacter) {
            completion(messageToCharacter)
        }
        
        // randow answer after a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let `self` = self else { return }
            let messageFromCharacter = self.messageService.randomMessage(for: .character,
                                                                         characterId: self.character.id.default)
            self.realmManager.add(object: messageFromCharacter, handler: {
                self.onRandomAnswer.onNext(messageFromCharacter)
            })
        }
    }
    
    func loadMessages(completed: @escaping () -> ()) {
        // request to fictional server
        fillSections()
        // response is successful
        completed()
    }
    
    
    func sortSectionsByAscending() {
        sections.sort(by: < )
    }
    
    func reverceMessages() {
        sections.forEach{ section in
            section.reverceMessages()
        }
    }
    
    
    // MARK: - Private methods

    private func fillSections() {
       self.sections.removeAll()
       let messages = realm.objects(MessageChat.self).filter("characterId == \(character.id.default)")
        messages.forEach { (message) in
            print(message, message.author)
            let titleDate = formatDate(message.date)
            if let section = sections.filter({ $0.title == titleDate }).first {
                section.addMessage(message)
            } else {
                let section = ChatSection(title: titleDate, messages: [message])
                cast(section).map(addSection)
            }
        }
        self.sortSectionsByAscending()
        self.reverceMessages()
    }
}

class ChatSection: ChatSectionProtocol {
    
    // MARK: - Properties
    
    var title: String = ""
    var messages: [MessageChat] = []
    
    
    // MARK: - Initializations
    
    init(title: String, messages: [MessageChat]) {
        self.title = title
        self.messages.append(contentsOf: messages)
    }
    
    
    // MARK: - Public methods

    func addMessage(_ message: MessageChat) {
        self.messages.append(message)
    }
    
    func reverceMessages() {
        self.messages.reverse()
    }
}

protocol ChatSectionProtocol: Comparable {
    var title: String { get }
    var date: Date { get }
    var messages: [MessageChat] { get set }
    func addMessage(_ message: MessageChat)
    func reverceMessages()
}

extension ChatSectionProtocol  {
    var date: Date {
        return formatter().date(from: title) ?? messages.first?.date ?? Date()
    }
    
    // MARK: - Comparable
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.date == rhs.date
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.date < rhs.date
    }
}


// local formatter date

fileprivate func formatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
   // dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    dateFormatter.dateFormat = "dd MMMM yyyy"
    
    return dateFormatter
}

fileprivate func formatDate(_ date: Date) -> String {
    return formatter().string(from: date)
}



