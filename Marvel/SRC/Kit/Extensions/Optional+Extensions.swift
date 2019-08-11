//
//  Optional+Extensions.swift
//  SearchGiphy
//
//  Created by Volodymyr
//  Copyright © 2019 java. All rights reserved.
//

import Foundation

func cast<Value, Result>(_ value: Value) -> Result? {
    return value as? Result
}

extension Optional where Wrapped == String {
    var `default`: String {
        return self ?? ""
    }
}

extension Optional where Wrapped == Int {
    var `default`: Int {
        return self ?? 0
    }
}

extension Optional where Wrapped == Bool {
    var `default`: Bool {
        return self ?? true
    }
}

extension Optional {
    var isEmpty: Bool {
        return self == nil
    }
}
