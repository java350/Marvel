//  UiViewController+Extensions.swift
//  Marvel
//
//  Created by Volodymyr
//  Copyright © 2019 Ukraine. All rights reserved.
//

import UIKit

extension UIViewController {
    static var name: String {
        return String(describing: self)
    }
}

extension UIViewController {
    func presentAlertWithTitle(title: String, message : String, onDismiss: (()->())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            
            onDismiss?()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
