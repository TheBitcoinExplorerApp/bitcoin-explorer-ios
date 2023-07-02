//
//  BlockModel.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 15/05/23.
//

import SwiftUI

struct Blocks: Hashable, Codable {
  let id: String
  let height: Int
  let size: Double
  let tx_count: Int64
  let timestamp: TimeInterval
  let extras: Extras
  
  func formatTimestamp(_ timestamp: TimeInterval) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "pt_BR")
          dateFormatter.timeStyle = .short
          
          let date = Date(timeIntervalSince1970: timestamp)
          return dateFormatter.string(from: date)
   
  }
  
  func formatTimestampWithHour(_ timestamp: TimeInterval) -> String {
          let dateFormatter = DateFormatter()
          //dateFormatter.locale = Locale(identifier: "pt_BR")
          dateFormatter.dateFormat = "dd/MM/yyyy  HH:mm"
          //dateFormatter.timeZone = .short
          
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
