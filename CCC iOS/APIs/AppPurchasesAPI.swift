//
//  AppPurchasesAPI.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 20/03/2021.
//  Copyright © 2021 roddy.io. All rights reserved.
//

import Combine
import Purchases

final class AppPurchasesAPI {
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    func offerings() -> AnyPublisher<Purchases.Offerings, Error> {
        Purchases.shared.offerings()
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func purchaserInfo() -> AnyPublisher<Purchases.PurchaserInfo, Error> {
        Purchases.shared.purchaserInfo()
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func restoreTransactions() -> AnyPublisher<Purchases.PurchaserInfo, Error> {
        Purchases.shared.restoreTransactions()
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func purchase(_ package: Purchases.Package) -> AnyPublisher<PurchaseResult, Error> {
        Purchases.shared.purchase(package)
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
