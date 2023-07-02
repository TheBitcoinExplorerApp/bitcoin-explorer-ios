//
//  AddressHeaderModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

struct AddressHeaderModel: Hashable, Codable {
  let chain_stats: ChainStats
}

struct ChainStats: Hashable, Codable {
  // total received
  let funded_txo_sum: Double
  // total sent
  let spent_txo_sum: Double
}
