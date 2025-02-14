//
//  Coins.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import Foundation

struct Coins2: Codable {
    let BRL: Last
    let CNY: Last
    let RUB: Last
}

struct Last: Codable {
    let last: Double
}

struct Coins: Codable {
    let USD: Double
    let EUR: Double
    let GBP: Double
    let CAD: Double
    let CHF: Double
    let AUD: Double
    let JPY: Double
}

