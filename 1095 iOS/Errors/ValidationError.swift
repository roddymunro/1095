//
//  ValidationError.swift
//  ValidationError
//
//  Created by Roddy Munro on 2021-09-02.
//

import Foundation

enum ValidationError: Error {
    case startAfterEnd
    case endAfterToday
    case startAfterToday
    case noEntryStatus
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .startAfterEnd:
            return NSLocalizedString(
                "The start date you have selected is after your end date. Please select an eligible start date and try again.",
                comment: ""
            )
        case .endAfterToday:
            return NSLocalizedString(
                "The end date you have selected is after today. Please select an eligible end date or mark this trip as an 'Ongoing Trip' and try again.",
                comment: ""
            )
        case .startAfterToday:
            return NSLocalizedString(
                "The start date you have selected is after today. Please select an eligible start date and try again.",
                comment: ""
            )
        case .noEntryStatus:
            return NSLocalizedString(
                "No entry status has been selected. Please select an entry status and try again.",
                comment: ""
            )
        }
    }
}
