//
//  DifficultyAdjustment.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 31/01/25.
//

struct DifficultyAdjustment: Hashable, Decodable {
    let progressPercent: Double
    let remainingBlocks: Int
}
