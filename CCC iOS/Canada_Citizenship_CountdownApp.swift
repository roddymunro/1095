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
    
    @StateObject var viewModel = EntriesViewModel()
    
    init() {
        WidgetCenter.shared.reloadAllTimelines()
        
        if let revcat_api_key = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String {
            Purchases.configure(withAPIKey: revcat_api_key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
