//
//  MessageHeaderView.swift
//
//  Created by Volodymyr.
//  Copyright © 2019 DANUBIASOFT. All rights reserved.
//

import UIKit

class MessageHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    @IBOutlet weak var labelName: UILabel!
    
    
    // MARK: - Public methods
    
    func fill(with text: String) {
        self.labelName.text = text
    }
    
    func fill(with date: Date)  {
        self.fill(with: date.string(with: .dayFullMounthYear))
    }
}
