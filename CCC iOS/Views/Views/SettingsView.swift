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
                                title: Text("You are running Ceramispace v\(viewModel.appVersion)"),
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
            }
            
            Section {
                SettingsRow(icon: "star", text: "Leave a Review", action: viewModel.leaveReviewTapped, block: true)
            }
            
            Section(header: Text("About")) {
                SettingsRow(icon: "sparkles", text: "Welcome", action: viewModel.showWelcome, block: true)
                SettingsRow(icon: "info.circle", text: "App Version", action: viewModel.showAppVersion, block: true)
            }
        }
    }
}
