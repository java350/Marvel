//
//  ChatViewController.swift
//
//  Created by Volodymyr.
//  Copyright © 2019 DoneIt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ChatEvent {}

class ChatViewController: UIViewController, RootView {
    
    // MARK: - Properties
    
    typealias ViewType = ChatView
    var events = PublishSubject<ChatEvent>()
    
    private let viewModel: ChatViewModel<ChatSection>
    private var dataSource: ChatDataSource?
    private var bag = DisposeBag()
    
    
    // MARK: - Initializations
    
    init(_ viewModel: ChatViewModel<ChatSection>) {
        self.viewModel = viewModel
        
        super.init(nibName: ChatViewController.name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.loadMessages()
        self.bind()
        self.configure()
        self.setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - IBAction
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.rootView?.keyboardWillShow(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.rootView?.keyboardWillHide(notification: notification)
    }
    
    
    // MARK: - Private methods
    
    private func loadMessages() {
        self.viewModel.loadMessages { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                self?.rootView?.textFieldContent.becomeFirstResponder()
            })
            self?.rootView?.tableView.map {
                $0.reloadData(with: .transitionCrossDissolve)
                //$0.reloadData()
                $0.scrollToLastRow(after: 0.2)
            }
        }
    }
    
    private func bind() {
        self.rootView?.buttonSend.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sendMessage((self?.rootView?.textFieldContent.text).default)
            }).disposed(by: bag)
        
        self.viewModel.onRandomAnswer.subscribe(onNext: {[weak self] (message) in
            self?.receiveMessage(message)
        }).disposed(by: bag)
    }
    
   private func configure() {
        self.rootView?.textFieldContent.delegate = self
    }
    
    private func sendMessage(_ text: String) {
        if text.isEmpty { return }
        self.rootView?.textFieldContent.text = ""
        viewModel.sendMessage(text: text) { [weak self] (message) in
            self?.viewModel.addMessage(message)
            self?.updateTableView(at: message)
        }
    }
    
    private func receiveMessage(_ message: MessageChat) {
        self.viewModel.addMessage(message)
        self.updateTableView(at: message)
    }
    
    private func updateTableView(at message: MessageChat) {
        DispatchQueue.main.async {
            guard let tableView = self.rootView?.tableView else { return }
            tableView.updateTableView {
                let sections = self.viewModel.sections
                let numberOfSections = max(sections.count - 1, 0)
                let numberOfMessages = max((sections.last?.messages.count).default - 1, 0)
                let indexPath = IndexPath(row: numberOfMessages, section: numberOfSections)
                
                if sections.count > tableView.numberOfSections {
                    tableView.insertSections([numberOfSections], with: .fade)
                } else {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                tableView.scrollToLastRow(after: 0.2)
            }
        }
    }
    
    private func setupTableView() {
        let tableView = self.rootView?.tableView
        dataSource = viewModel.dataSource(with: rootView?.tableView)
        tableView?.register(cellClass: CharacterMessageCell.self)
        tableView?.register(cellClass: PlayerMessageCell.self)
        tableView?.register(cellHeaderClass: MessageHeaderView.self)
        tableView?.dataSource = dataSource
        tableView?.delegate = self
        tableView?.tableFooterView = UIView()
        tableView?.scrollToLastRow(after: 0.2)
    }
}


extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MessageHeaderView.self) ) as? MessageHeaderView
        cell?.fill(with: viewModel.sections[section].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}


