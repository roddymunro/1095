//
//  ImageButtonStyle.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-06-03.
//

import SwiftUI

public struct ImageButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title.weight(.bold))
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.8) : Color.accentColor)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
    
}

extension ButtonStyle where Self == ImageButtonStyle {
    static var image: ImageButtonStyle { .init() }
}
