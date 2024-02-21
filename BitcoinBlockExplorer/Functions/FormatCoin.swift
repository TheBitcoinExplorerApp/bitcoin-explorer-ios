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
    
    // Define o símbolo da moeda
    formatter.currencySymbol = symbol
//    let currentSymbol = formatter.currencySymbol ?? ""
    
    if let formattedString = formatter.string(from: NSNumber(value: numero)) {
        return formattedString
    } else {
        return "\(numero)"
    }
}

// Somente para teste
//func formatarNumero(_ numero: Double) -> String {
//    let formatter = NumberFormatter()
//    formatter.numberStyle = .currency
//    
//    
//    // Define o símbolo da moeda
//    let currentSymbol = formatter.currencySymbol ?? ""
//    
//    if let formattedString = formatter.string(from: NSNumber(value: numero)) {
//        return formattedString
//    } else {
//        return "\(numero)"
//    }
//}
