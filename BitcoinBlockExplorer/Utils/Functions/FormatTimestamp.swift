//
//  FormatTimestamp.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 07/02/25.
//

import Foundation


func formatTimestampWithHour(_ timestamp: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    dateFormatter.timeZone = .current
    
    let date = Date(timeIntervalSince1970: timestamp)
    return dateFormatter.string(from: date)
}

func formatTipeFullDate(_ timestamp: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    dateFormatter.timeZone = .current
    
    let date = Date(timeIntervalSince1970: timestamp)
    return dateFormatter.string(from: date)
}
