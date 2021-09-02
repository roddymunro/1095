//
//  PurchasesError.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 30/11/2020.
//  Copyright © 2020 roddy.io. All rights reserved.
//

import Foundation

enum PurchasesError: Error {
    case purchasesDisabled
    case purchaseInvalidError
    case transactionFailed
    case missingEntitlement
}

extension PurchasesError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .purchasesDisabled:
            return NSLocalizedString(
                "You appear to have in-app purchases disabled. Check your device settings and try again.",
                comment: ""
            )
        case .purchaseInvalidError:
            return NSLocalizedString(
                "Purchase invalid, please check your payment source and try again.",
                comment: ""
            )
        case .transactionFailed:
            return NSLocalizedString(
                "The transaction is in a failed state.",
                comment: ""
            )
        case .missingEntitlement:
            return NSLocalizedString(
                "The 'Premium' entitlement was not found.",
                comment: ""
            )
        }
    }
}
