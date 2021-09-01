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
}
