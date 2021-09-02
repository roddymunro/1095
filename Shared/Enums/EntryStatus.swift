//
//  EntryStatus.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import Foundation

enum EntryStatus: StringLiteralType, CaseIterable {
    case permanentResident = "Permanent Resident"
    case protectedPerson = "Protected Person"
    case student = "Student"
    case temporaryResident = "Temporary Resident"
    case worker = "Worker"
    case visitor = "Visitor"
    
    var multiplier: Double {
        switch self {
            case .permanentResident:
                return 1
            default:
                return 0.5
        }
    }
    
    var daysContributionString: String {
        if multiplier == 1 {
            return "one day"
        } else if multiplier == 0.5 {
            return "half a day"
        } else {
            return ""
        }
    }
}

extension EntryStatus: Codable {}
