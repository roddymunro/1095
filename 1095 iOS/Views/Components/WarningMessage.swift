//
//  WarningMessage.swift
//  WarningMessage
//
//  Created by Roddy Munro on 2021-09-02.
//

import SwiftUI

struct WarningMessage: View {
    
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .symbolRenderingMode(.palette)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .foregroundStyle(.black, .yellow)
            Text(text)
                .font(.headline.weight(.medium))
                .multilineTextAlignment(.leading)
        }.padding()
    }
}
