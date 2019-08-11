//
//  Character.swift
//  Marvel
//
//  Created by Volodymyr.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import Foundation

struct Thumbnail: Decodable {
    let path: String?
    let `extension`: String?
    
    var fullImageUrl: String {
        return path.default + "." + `extension`.default
    }
}

struct Character: Decodable {
    var id: Int?
    var name: String?
    var thumbnail: Thumbnail
}
