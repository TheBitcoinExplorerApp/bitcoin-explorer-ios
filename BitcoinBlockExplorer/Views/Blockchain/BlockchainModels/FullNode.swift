//
//  FullNode.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 30/01/25.
//

struct FullNode: Hashable, Decodable {
    let results: [Resultados]
}

struct Resultados: Hashable, Decodable {
    let total_nodes: Int
}
