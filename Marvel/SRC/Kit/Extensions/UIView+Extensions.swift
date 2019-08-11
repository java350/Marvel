//
//  UIView+Extensions.swift
//  Taxikey-Passenger
//
//  Created by Volodymyr
//  Copyright © 2019 DoneIt. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public func roundAllCorners(_ radius: Float) {
        self.roundCorners(.allCorners, radius: radius)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: Float) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if corners.contains(.topLeft) {
              cornerMask.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight) {
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = CGFloat(radius)
            self.layer.maskedCorners = cornerMask
        } else {
            let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners,
                                         cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
            
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    public func applyBorder(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {

        
        let borderPath = UIBezierPath.init(roundedRect: self.bounds,
                                           byRoundingCorners: corners,
                                           cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
}

extension UIView {
    func addBorder(color: UIColor = .black, thickness: CGFloat = 1, opacity: CGFloat = 1) {
        self.layer.borderWidth = thickness
        self.layer.borderColor = color.withAlphaComponent(opacity).cgColor
    }
}
