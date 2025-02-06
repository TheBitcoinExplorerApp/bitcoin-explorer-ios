//
//  FormatCoin.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import Foundation

func formatCoin(_ numero: Double, symbol: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = symbol
    
    if let formattedString = formatter.string(from: NSNumber(value: numero)) {
        return formattedString
    } else {
        return "\(numero)"
    }
}

