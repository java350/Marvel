//
//  DriverMessageCell.swift
//
//  Created by Volodymyr.
//  Copyright © 2019 DANUBIASOFT. All rights reserved.
//

import UIKit

class CharacterMessageCell: FillableChatCell<MessageChat> {
    
    
    // MARK: - IBOutlets
    
    typealias model = MessageChat
    
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    private var isFirstMessage = false
    
    
    // MARK: - Initializations
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            let corners: UIRectCorner = self.isFirstMessage ? [.topRight, .bottomRight, .bottomLeft] : .allCorners
            self.viewMessage.roundCorners(corners, radius: 8)
            self.viewMessage.applyBorder(corners, radius: 8, borderColor: .lightGray, borderWidth: 1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // remove old CAShapeLayer
        self.viewMessage.layer.sublayers?.forEach {
            if $0.isKind(of: CAShapeLayer.self) {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    
    // MARK: - Public methods
    
    override func fill(_ model: MessageChat, firstMessage: Bool = false, avatarUrl: String = "") {
        self.isFirstMessage = firstMessage
        self.imageViewAvatar.isHidden = !firstMessage
        
        self.imageViewAvatar.setImage(with: avatarUrl, defaultImage: #imageLiteral(resourceName: "noImage"))
        self.labelMessage.text = model.content
        self.labelTime.text = model.date.string(with: .hours24)
    }
    
    
    // MARK: - Provate methods
    
    func setupUI() {
        imageViewAvatar.layer.cornerRadius = imageViewAvatar.frame.width / 2
    }
}
