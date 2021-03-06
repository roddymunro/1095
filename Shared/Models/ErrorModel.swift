//
//  ErrorModel.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation

public struct ErrorModel: Identifiable {
    public var id = UUID()
    private(set) var title: String
    private var error: Error
    
    var message: String {
        error.localizedDescription
    }
    
    init(_ title: String, _ error: Error) {
        self.title = title
        self.error = error
    }
}
