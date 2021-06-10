//
//  TravelEntry.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import Foundation

struct TravelEntry: Identifiable {
    var id: String
    var entryStatus: EntryStatus
    var startDate: Date
    var endDate: Date? = nil
    var details: String
}

extension TravelEntry: Codable {}
extension TravelEntry: Equatable {}
