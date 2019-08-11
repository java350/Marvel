//
//  Date+Formatting.swift
//  Taxikey-Passenger
//
//  Created by Volodymyr
//  Copyright © 2019 DoneIt. All rights reserved.
//

import Foundation

public enum DatePattern {
    case format(String)
    
    func dateFormatter() -> DateFormatter {
        return DateFormatter.dateFormatter(with: self)
    }
}

public extension Date {
    func string(with datePattern: DatePattern) -> String {
        return datePattern.dateFormatter().string(from: self)
    }
}

public extension String {
    func date(with format: DatePattern) -> Date? {
        return format.dateFormatter().date(from: self)
    }
}

fileprivate extension DateFormatter {
    static func dateFormatter(with format: DatePattern) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US")
        switch format {
        case .format(let pattern):
            formatter.dateFormat = pattern
        }
        return formatter
    }
}

extension DatePattern {
    
    // General
    
    static var hours: DatePattern {
        return .format("h:mm a")
    }
    
    static var hours24: DatePattern {
        return .format("HH:mm")
    }
    
    static var date: DatePattern {
        return .format("yyyy MM dd")
    }
    
    static var dayMounthYear: DatePattern {
        return .format("dd/MM/yyyy")
    }
    
    static var dayFullMounthYear: DatePattern {
        return .format("dd MMMM yyyy")
    }
    
    static var mounthDayYear: DatePattern {
        return .format("MM/dd/yyyy")
    }
    
    static var month: DatePattern {
        return .format("MMMM")
    }
    
    static var year: DatePattern {
        return .format("yyyy")
    }
    
    // Context related
    
    static var price: DatePattern {
        return .format("MM.dd.yy")
    }
    
    static var schedule: DatePattern {
        return .format("E, d MMM")
    }
    
    static var full: DatePattern {
        return .format("H:mm a MM/dd/yyyy")
    }
    
    static var fullAlternate: DatePattern {
        return .format("MM/dd/yyyy, H:mm a")
    }
    
    static var fullWithMilliseconds: DatePattern {
        return .format("y-MM-dd H:m:ss.SSSS")
    }
}

