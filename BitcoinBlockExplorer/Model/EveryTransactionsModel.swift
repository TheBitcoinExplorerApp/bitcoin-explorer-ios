//
//  TransactionModel.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 17/05/23.
//

import SwiftUI

struct EveryTransactionsModel: Hashable, Codable {
  let txid: String
  let fee: Double
  let value: Double
}
