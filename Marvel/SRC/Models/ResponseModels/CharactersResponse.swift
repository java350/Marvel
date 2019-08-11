//
//  ResponseCharacters.swift
//  Marvel
//
//  Created by Volodymyr.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import Foundation

struct CharactersResponse: Decodable {
    
    struct Data: Decodable {
        let offset: Int?
        let limit: Int?
        let total: Int?
        let count: Int?
        let results: [Character]?
    }
    
    var code: Int?
    var data: Data?
    
    var characters: [Character] {
        return data?.results ?? []
    }
}
