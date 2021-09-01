//
//  WelcomeView.swift
//  Canada Citizenship Countdown
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let newFeatures: [NewFeature] = [
        NewFeature(iconName: "exclamationmark.triangle.fill", title: "Please Note", description: "Before applying for your Canadian citizenship, always double-check your eligibility on the Government of Canada website."),
        NewFeature(iconName: "square.grid.3x3.topleft.fill", title: "Unlock Widgets", description: "While this app is free, a widget is available for those that leave a tip. You can leave a tip on the 'Settings' screen."),
        NewFeature(iconName: "star.fill", title: "Support the Developer", description: "Please consider leaving a positive review on the App Store. There is also the option to 'tip' the developer inside the app, though this is not mandatory, it is very much appreciated!")
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: isIpad ? 64 : 32) {
                    Text("Thank You For Downloading").titleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.top, isIpad ? 80 : 32)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(newFeatures, content: NewFeatureRow.init)
                    }
                }
                .padding()
            }
            
            Button(action: { dismiss() }, label: { Text("Continue") }).buttonStyle(.primary)
                .padding(.bottom, isIpad ? 64 : 32)
        }.padding(.horizontal, isIpad ? 128 : 24)
    }
}

struct NewFeatureRow: View {
    let feature: NewFeature
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: feature.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .foregroundColor(.accentColor)
                .padding(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title).headerStyle()
                Text(feature.description).foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
