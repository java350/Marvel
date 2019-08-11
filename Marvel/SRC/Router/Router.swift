//
//  Router.swift
//  Marvel
//
//  Created by Volodymyr on 8/11/19.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import Foundation
import UIKit

final class Router: NSObject {
    
    // MARK: - Variables
    var navigationViewController: UINavigationController! {
        didSet {
            navigationViewController.delegate = self
        }
    }
    
    // MARK: - Class properties
    static let share = Router()
    
    
    // MARK: - Initializations
    private override init() {
        super.init()
    }
    
    
    // MARK: - Public methods
    
    func showChatScreen(for character: Character) {
        let viewModel = ChatViewModel<ChatSection>(character: character)
        let controller = ChatViewController(viewModel)
        navigationViewController.pushViewController(controller, animated: true)
    }
    
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool)
    {
        let backButton = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: nil,
            action: nil
        )
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
