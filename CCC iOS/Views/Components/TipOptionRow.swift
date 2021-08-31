//
//  TipOptionRow.swift
//  TipOptionRow
//
//  Created by Roddy Munro on 2021-08-31.
//

import SwiftUI

struct TipOptionRow: View {
    
    let action: ()->()
    let option: TipOption
    let price: String
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(option.emoji)
                    .font(.title3)
                Text(option.name)
                Spacer()
                Text(price)
                    .bold()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(Color.accentColor.clipShape(RoundedRectangle(cornerRadius: 6)))
                    .foregroundColor(.white)
            }
        }.buttonStyle(.plain)
    }
}

struct TipOption_Previews: PreviewProvider {
    
    static var previews: some View {
        Form {
            Section {
                TipOptionRow(action: {}, option: .init(id: "CCCDonutTip", order: 1, emoji: "🍩", name: "Donut Tip"), price: "$1.99")
            }
        }
    }
}
