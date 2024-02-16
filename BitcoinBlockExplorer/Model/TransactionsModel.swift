//
//  BlockTransactionsModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct Transactions: Hashable, Codable {
    let txid: String
    let size: Int32
    let fee: Double
    let vin: [Vin]
    let vout: [Vout]
    let status: Status
}

struct Vin: Hashable, Codable {
    let prevout: Prevout?
}

struct Prevout: Hashable, Codable {
    let scriptpubkey_address: String
    let value: Double
}

struct Vout: Hashable, Codable {
    let scriptpubkey_address: String?
    let value: Double
}

struct Status: Hashable, Codable {
    let confirmed: Bool
    let block_height: Int64?
    let block_hash: String?
    let block_time: TimeInterval?
    
    func formatTime(_ block_time: TimeInterval) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        
        let date = Date(timeIntervalSince1970: block_time)
        return dateFormatter.string(from: date)
        
    }
    
}
