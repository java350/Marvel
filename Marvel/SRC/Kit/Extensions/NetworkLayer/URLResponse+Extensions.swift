//
//  URLResponce+Extensions.swift
//  SearchGiphy
//
//  Created by Volodymyr
//  Copyright © 2019 java. All rights reserved.
//

import Foundation

extension URLResponse {
    
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
    
    func isSuccessCode(_ statusCode: Int) -> Bool {
        return 200...299 ~= statusCode
    }
    
    func isSuccessCode() -> Bool {
        guard let statusCode = getStatusCode() else {
            return false
        }
        return isSuccessCode(statusCode)
    }
}
