//
//  Date+Ext.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-10.
//

import Foundation

extension Date {
    static var tomorrow: Date {
        return Date().dayAfter
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

extension Date: RawRepresentable {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    public var rawValue: String {
        Date.dateFormatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.dateFormatter.date(from: rawValue) ?? Date()
    }
}
