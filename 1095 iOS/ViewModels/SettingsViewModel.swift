//
//  SettingsViewModel.swift
//  SettingsViewModel
//
//  Created by Roddy Munro on 2021-08-31.
//

import SwiftUI
import Combine
import Purchases

class SettingsViewModel: ObservableObject {
    
    let ud = UserDefaults(suiteName: "group.com.roddy.io.Canada-Citizenship-Countdown")!
    
    let purchasesApi = AppPurchasesAPI()
    private var disposables = Set<AnyCancellable>()
    
    @Published var tips: [TipOption: Purchases.Package?] = [
        .donut: nil,
        .iceCream: nil,
        .taco: nil,
        .burrito: nil
    ]
    
    @Published var activeSheet: ActiveSheet?
    @Published var activeAlert: ActiveAlert?
    @Published var activeActionSheet: ActiveActionSheet?
    
    public let bio: String = """
    Hello! 👋 I'm Roddy, the only developer behind this app.
    
    I have decided to make this app available for free. However, if you feel like this app has helped in anyway, I would really appreciate a 'tip' from the options below. 🎁
    
    While I do enjoy it, developing apps takes up a lot of my time, and any tips received will help to motivate me to work on new features and improvements. 🛠
    
    Thank you!
    """
    
    var appVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    init() {
        fetchPackages()
    }
    
    public func showWelcome() {
        activeSheet = .welcome
    }
    
    public func showAppVersion() {
        activeAlert = .appVersion
    }
    
    public func leaveReviewTapped() {
        if let url = URL(string: "https://apps.apple.com/app/id1583814914?action=write-review") {
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
    
    public func openConfettiView() {
        if let url = URL(string: "https://github.com/ziligy/ConfettiView/blob/master/LICENSE") {
            activeSheet = .webview(url)
        }
    }
    
    public func openOfficialCalculator() {
        if let url = URL(string: "https://eservices.cic.gc.ca/rescalc/resCalcStartNew.do") {
            activeSheet = .webview(url)
        }
    }
    
    public func openPrivacyPolicy() {
        if let url = URL(string: "https://gist.github.com/roddymunro/5cb2a382a6785b5847fbb4f6109615b8") {
            activeSheet = .webview(url)
        }
    }
    
    public func fetchPackages() {
        purchasesApi
            .offerings()
            .sink { [weak self] error in
                if case .failure(let error) = error {
                    self?.activeAlert = .error(.init("Unable to Fetch Tips", error))
                }
            } receiveValue: { [weak self] offerings in
                guard let self = self else { return }
                if let packages = offerings.current?.availablePackages {
                    for option in self.tips.keys {
                        self.tips[option] = packages.first { $0.identifier == option.id }
                    }
                }
            }
            .store(in: &disposables)
    }
    
    public func tipTapped(_ package: Purchases.Package?) {
        do {
            try purchase(package)
        } catch {
            self.activeAlert = .error(.init("Couldn't Complete Purchase", error))
        }
    }
    
    private func purchase(_ package: Purchases.Package?) throws {
        guard let package = package else { return }
        guard Purchases.canMakePayments() else { throw PurchasesError.purchasesDisabled }
        
        purchasesApi
            .purchase(package)
            .sink { [weak self] error in
                if case .failure(let error) = error {
                    self?.activeAlert = .error(.init("Couldn't Complete Purchase", error))
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                guard result.transaction.transactionState != .failed else {
                    self.activeAlert = .error(.init("Couldn't Complete Purchase", PurchasesError.transactionFailed))
                    return
                }
                
                guard result.purchaserInfo.entitlements["Premium"] != nil else {
                    self.activeAlert = .error(.init("Couldn't Complete Purchase", PurchasesError.missingEntitlement))
                    return
                }
            }
            .store(in: &disposables)
    }
    
    enum ActiveSheet { case welcome, webview(_ url: URL) }
    enum ActiveAlert { case error(_ error: ErrorModel), appVersion }
    enum ActiveActionSheet { case deeplink(_ appUrl: URL, _ webUrl: URL) }
}
