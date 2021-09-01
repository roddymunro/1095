//
//  Purchases+Ext.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 20/03/2021.
//  Copyright © 2021 roddy.io. All rights reserved.
//

import Foundation
import Purchases
import Combine
import WidgetKit

enum PurchaseError: Error {
    case noResultError
    case userCancelled
}

struct PurchaseResult {
    let transaction: SKPaymentTransaction
    let purchaserInfo: Purchases.PurchaserInfo
}

extension Purchases {
    
    static let ud = UserDefaults(suiteName: "group.com.roddy.io.Canada-Citizenship-Countdown")!
    
    func offerings() -> Future<Purchases.Offerings, Error> {
        Future { promise in
            Purchases.shared.offerings { (offerings, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let offerings = offerings {
                    promise(.success(offerings))
                } else {
                    promise(.failure(PurchaseError.noResultError))
                }
            }
        }
    }
    
    func purchaserInfo() -> Future<PurchaserInfo, Error> {
        Future { promise in
            Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let info = purchaserInfo {
                    promise(.success(info))
                } else {
                    promise(.failure(PurchaseError.noResultError))
                }
            }
        }
    }
    
    func restoreTransactions() -> Future<PurchaserInfo, Error> {
        Future { promise in
            Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let info = purchaserInfo {
                    promise(.success(info))
                } else {
                    promise(.failure(PurchaseError.noResultError))
                }
            }
        }
    }
    
    func purchase(_ package: Purchases.Package) -> Future<PurchaseResult, Error> {
        Future { promise in
            Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                if let error = error {
                    promise(.failure(error))
                } else if userCancelled {
                    promise(.failure(PurchaseError.userCancelled))
                } else if let transaction = transaction, let info = purchaserInfo {
                    Self.ud.set(true, forKey: "isPaid")
                    WidgetCenter.shared.reloadAllTimelines()
                    promise(.success(PurchaseResult(transaction: transaction, purchaserInfo: info)))
                } else {
                    promise(.failure(PurchaseError.noResultError))
                }
            }
        }
    }
}
