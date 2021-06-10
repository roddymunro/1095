//
//  Text+ViewModifier.swift
//  Canada Citizenship Countdown
//

import SwiftUI

extension Text {
    func titleStyle() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
    }
    
    func captionStyle() -> some View {
        self
            .font(.caption)
    }
    
    func formLabelStyle() -> some View {
        self
            .fontWeight(.medium)
    }
    
    func headerStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
    }
}
