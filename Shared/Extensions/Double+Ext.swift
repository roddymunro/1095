//
//  Double+Ext.swift
//  Double+Ext
//
//  Created by Roddy Munro on 2021-09-02.
//

import Foundation

extension Double {
    
    func formatToWholeNumberOrOneDecimalPoint() -> String {
        if floor(self) == self {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.1f", self)
        }
    }
    
}
