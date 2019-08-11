//
//  PassengerMessageCell.swift
//
//  Created by Volodymyr
//  Copyright © 2019 DANUBIASOFT. All rights reserved.
//

import UIKit

class FillableChatCell<T>: UITableViewCell {
    func fill(_ model: T, firstMessage: Bool = false, avatarUrl: String = "") {}
}

class PlayerMessageCell: FillableChatCell<MessageChat> {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    
    // MARK: - Initializations
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewMessage.roundCorners([.topLeft, .bottomLeft, .bottomRight], radius: 8)
            self.viewMessage.layer.masksToBounds = true
        }
    }
    
    
    // MARK: - Public methods
    
    override func fill(_ model: MessageChat, firstMessage: Bool, avatarUrl: String) {
        self.labelMessage.text = model.content
        self.labelTime.text = model.date.string(with: .hours24)
    }
    
    // MARK: - Provate methods
    
    func setupUI() { }
    
}
