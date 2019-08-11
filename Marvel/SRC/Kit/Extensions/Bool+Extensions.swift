//
//  Boll+Extensions.swift
//  Marvel
//
//  Created by Volodymyr on 8/11/19.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import CoreGraphics

extension Bool {
    var float: CGFloat {
        return self ? CGFloat(1) : CGFloat(0)
    }
}
