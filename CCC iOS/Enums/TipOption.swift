//
//  TipOption.swift
//  TipOption
//
//  Created by Roddy Munro on 2021-08-31.
//

import Foundation

struct TipOption: Identifiable, Hashable {
    
    let id: String
    let order: Int
    let emoji: String
    let name: String
    
    static let donut: TipOption = .init(id: "DonutTip", order: 1, emoji: "🍩", name: "Donut Tip")
    static let iceCream: TipOption = .init(id: "IceCreamTip", order: 2, emoji: "🍦", name: "Ice Cream Tip")
    static let taco: TipOption = .init(id: "TacoTip", order: 3, emoji: "🌮", name: "Taco Tip")
    static let burrito: TipOption = .init(id: "BurritoTip", order: 4, emoji: "🌯", name: "Burrito Tip")
}
