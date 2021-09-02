//
//  TravelEntry.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import Foundation

extension TravelEntry {
    var entryStatus: EntryStatus {
        get {
            return EntryStatus(rawValue: self.entryStatusValue!)!
        }
        set {
            self.entryStatusValue = newValue.rawValue
        }
    }
    
    var daysContribution: Double {
        let calendar = Calendar.current
        let fiveYearsAgo = calendar.startOfDay(for: calendar.date(byAdding: DateComponents(year: -5), to: Date())!)
        
        guard let startDate = startDate else { return 0 }
        
        let start = startDate >= fiveYearsAgo ? calendar.startOfDay(for: startDate) : fiveYearsAgo
        let endDate = calendar.startOfDay(for: endDate ?? Date())

        let components = calendar.dateComponents([.day], from: start, to: endDate)
        let calendarDays = (components.day ?? 0) + (entryStatus == .permanentResident ? 0 : 1)
        
        return Double(calendarDays) * entryStatus.multiplier
    }
}
