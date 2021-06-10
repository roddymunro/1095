//
//  Canada_Citizenship_CountdownApp.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI

@main
struct Canada_Citizenship_CountdownApp: App {
    
    @StateObject var viewModel = EntriesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
