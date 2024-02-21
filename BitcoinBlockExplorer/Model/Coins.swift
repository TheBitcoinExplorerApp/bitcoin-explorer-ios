//
//  Coins.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import Foundation
 
//struct Coins: Hashable, Codable {
//    let current_price: Double
//}


struct Coins: Codable {
    let USD: Double
    let EUR: Double
    let GBP: Double
    let CAD: Double
    let CHF: Double
    let AUD: Double
    let JPY: Double
}
