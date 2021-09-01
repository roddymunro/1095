//
//  Canada_Citizenship_CountdownApp.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI
import WidgetKit
import Purchases

@main
struct Canada_Citizenship_CountdownApp: App {
    
    private let coreDataHelper = CoreDataHelper.shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        WidgetCenter.shared.reloadAllTimelines()
        
        if let revcat_api_key = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String {
            Purchases.configure(withAPIKey: revcat_api_key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataHelper.context)
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                        case .active:
                            print("app now active")
                        default:
                            coreDataHelper.saveContext()
                    }
                }
        }
    }
}
