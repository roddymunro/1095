//
//  Alert+Ext.swift
//  Canada Citizenship Countdown
//
//  Created by Roddy Munro on 2021-05-17.
//

import SwiftUI

extension Alert {
    public static func errorAlert(_ error: ErrorModel) -> Alert {
        Alert(title: Text(error.title), message: Text(error.message))
    }
}
