//
//  SettingsViewModel.swift
//  SettingsViewModel
//
//  Created by Roddy Munro on 2021-08-31.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    
    @Published var activeSheet: ActiveSheet?
    @Published var activeAlert: ActiveAlert?
    @Published var activeActionSheet: ActiveActionSheet?
    
    public let bio: String = """

    """
    
    var appVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    init() {
    }
    
    public func showWelcome() {
        activeSheet = .welcome
    }
    
    public func showAppVersion() {
        activeAlert = .appVersion
    }
    
    public func leaveReviewTapped() {
        if let url = URL(string: "https://apps.apple.com/app/id1526050930?action=write-review") {
            activeSheet = .webview(url)
        }
    }
    
    public func canOpenApp(appUrl: URL) -> Bool {
        return UIApplication.shared.canOpenURL(appUrl)
    }
    
    public func handleUrl(appUrl: URL, webUrl: URL) {
        if canOpenApp(appUrl: appUrl) {
            activeActionSheet = .deeplink(appUrl, webUrl)
        } else {
            openUrl(webUrl)
        }
    }
    
    public func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    public func openRoddyWebsite() {
        if let url = URL(string: "https://roddy.io") {
            activeSheet = .webview(url)
        }
    }
    
    enum ActiveSheet { case welcome, webview(_ url: URL) }
    enum ActiveAlert { case error(_ error: ErrorModel), appVersion }
    enum ActiveActionSheet { case deeplink(_ appUrl: URL, _ webUrl: URL) }
}
