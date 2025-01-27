//
//  MempoolModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 26/01/25.
//

struct MempoolModel: Hashable, Decodable {
    let count: Int
    let total_fee: Double
}

struct MempoolSize: Hashable, Decodable {
    let blockSize: Double
    let blockVSize: Double
}
