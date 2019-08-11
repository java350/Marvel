//
//  ChatView.swift
//
//  Created by Volodymyr on 7/13/19.
//  Copyright © 2019 DoneIt. All rights reserved.
//

import UIKit

class ChatView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldContent: UITextField!
    @IBOutlet weak var stackViewBottom: UIStackView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Publick methods
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        self.updateConstarintsForKeyboard(constant: keyboardFrame.cgRectValue.height + 5)
    }
    
    func keyboardWillHide(notification: NSNotification) {
      self.updateConstarintsForKeyboard(constant: 25)
    }
    
    
    // MARK: - Private methods
    
    private func updateConstarintsForKeyboard(constant: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.stackViewBottomConstraint.constant = constant
            self.tableView.scrollToLastRow()
            self.layoutIfNeeded()
        }
    }
    
}
