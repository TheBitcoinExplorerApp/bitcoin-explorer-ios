//
//  Block.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 15/05/23.
//

import SwiftUI

struct Block: Hashable, Codable {
    let id: String // hash
    let height: Int
    let size: Double
    let tx_count: Int64
    let timestamp: TimeInterval
    let extras: Extras
    
    func formatTimestamp(_ timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
    
    func formatTimestampWithHour(_ timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
    
}

struct Extras: Hashable, Codable {
    let medianFee: Double
    let pool: Pool
}

struct Pool: Hashable, Codable {
    let name: String
}
