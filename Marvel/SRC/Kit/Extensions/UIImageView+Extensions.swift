//
//  UIImageView+Extensions.swift
//  SearchGiphy
//
//  Created by Volodymyr
//  Copyright © 2019 java. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

extension UIImageView {
    func setImage(with path: String?, defaultImage: UIImage? = #imageLiteral(resourceName: "noImage")) {
        
        func setDefaultImage(always: Bool = true) {
            if !always && !self.image.isEmpty { return }
            self.image = defaultImage
        }
        
        guard let path = path,
            let url = URL(string: path) else {
                setDefaultImage()
                return
        }
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageIndicator?.startAnimatingIndicator()
        self.sd_setImage(with: url, placeholderImage: defaultImage) {[weak self] _, _, _, _ in
            DispatchQueue.main.async {
                self?.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
    }
}
