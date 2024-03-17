//
//  Error.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 17/03/24.
//

import Foundation

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
