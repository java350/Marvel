//
//  Date+Extensions.swift
//  Taxikey-Passenger
//
//  Created by Volodymyr
//  Copyright © 2019 DoneIt. All rights reserved.
//

import Foundation


extension Date {
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        var components = calendar.dateComponents(unitFlags, from: self)
        components.timeZone = TimeZone(abbreviation: "UTC")
        
        return calendar.date(from: components) ?? self
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        components.timeZone = TimeZone(abbreviation: "UTC")
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        
        return (date?.addingTimeInterval(-1)) ?? self
    }
}
