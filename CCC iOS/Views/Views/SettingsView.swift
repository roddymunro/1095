//
//  SettingsView.swift
//  SettingsView
//
//  Created by Roddy Munro on 2021-08-31.
//

import SwiftUI
import RMSettingsRow
import RMDeveloperIntro

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: SettingsViewModel
    
    @AppStorage("shouldPlayConfetti") var shouldPlayConfetti: Bool = true
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Settings")
                .navigationBarItems(leading: Button("Close", action: { dismiss() }))
                .navigationViewStyle(.stack)
                .alert(using: $viewModel.activeAlert) { alert in
                    switch alert {
                        case .error(let error):
                            return .errorAlert(error)
                        case .appVersion:
                            return Alert(
                                title: Text("You are running version \(viewModel.appVersion)"),
                                message: Text(""),
                                dismissButton: .default(Text("Sweet!"))
                            )
                    }
                }
                .sheet(using: $viewModel.activeSheet) { sheet in
                    switch sheet {
                        case .welcome:
                            WelcomeView()
                        case .webview(let url):
                            WebViewSheet(url: url)
                    }
                }
                .actionSheet(using: $viewModel.activeActionSheet) { sheet in
                    switch sheet {
                        case .deeplink(let appUrl, let webUrl):
                            return ActionSheet(title: Text("Open Url"), message: Text("Would you like to open this URL in the app or in a web browser?"), buttons: [
                                .default(Text("App")) { viewModel.openUrl(appUrl) },
                                .default(Text("Web Browser")) { viewModel.activeSheet = .webview(webUrl) },
                                .cancel()
                            ])
                    }
                }
        }
    }
    
    var content: some View {
        Form {
            Section {
                DeveloperIntro(
                    profileImage: Image("DeveloperImage"),
                    bio: viewModel.bio,
                    actionButton: .init(action: viewModel.openRoddyWebsite, title: "Open Website", systemImage: "globe")
                )
            }.listRowBackground(Color.cell.edgesIgnoringSafeArea(.all))
            
            Section(header: Text("Tip Jar")) {
                ForEach(viewModel.tips.sorted { $0.key.order < $1.key.order }, id: \.key.id) { option, package in
                    if let package = package {
                        TipOptionRow(action: {
                            viewModel.tipTapped(package)
                        }, option: option, price: package.localizedPriceString)
                    }
                }
            }.listRowBackground(Color.cell.edgesIgnoringSafeArea(.all))
            
            Section {
                SettingsToggleRow(icon: "sparkles", text: "Show Confetti When Eligible?", toggledOn: $shouldPlayConfetti, block: true)
            }.listRowBackground(Color.cell.edgesIgnoringSafeArea(.all))
            
            Section {
                SettingsRow(icon: "heart.fill", text: "Leave a Review", action: viewModel.leaveReviewTapped, block: true)
                SettingsRow(icon: "hand.wave.fill", text: "Display Welcome", action: viewModel.showWelcome, block: true)
                SettingsRow(icon: "info.circle.fill", text: "App Version", action: viewModel.showAppVersion, block: true)
            }.listRowBackground(Color.cell.edgesIgnoringSafeArea(.all))
            
            Section(header: Text("With Thanks To")) {
                SettingsRow(icon: "sparkle", text: "ConfettiView", action: viewModel.openConfettiView, block: true)
            }
        }
    }
}
