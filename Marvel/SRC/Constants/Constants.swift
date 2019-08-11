//
//  Constants.swift
//
//  Created by  Volodymyr
//  Copyright © 2019 java. All rights reserved.
//

import UIKit

struct Constants {
    struct Server { 
        static let api = "https://gateway.marvel.com:443/v1/public/"
        
        struct key {
            static let APIKey = "apikey"
            static let characters = "characters"
            static let hash = "hash"
            static let ts = "ts"
            static let limit = "limit"
            static let offset = "offset"
        }
        
        static let characters = "characters"
        static let ts = "1"
        static let APIKey = "4fa8bf5ad1036d38b25127e9110d1935"
        static let hash = "9e98ee7efb398c7125d5104077a2c93f"
        static let offset = 50
    }
}

