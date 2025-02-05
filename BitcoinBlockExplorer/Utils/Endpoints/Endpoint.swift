
//
//  Endpoint.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 26/01/25.
//

enum Endpoint {
    case fees, blockHeader, blockTransactions(hash: String), eachBlockSearch(height: Int), coins, coins2, mempool, mempoolSize, lastBlock,
         fullNodes, hashrate, blockReward, difficultyAdjustment, eachTransactions(txId: String), addressHeader(address: String), addressTransactions(address: String), hash(height: Int), height(hash: String)
    
    var endpoint: String {
        switch self {
        case .fees:
            return "https://mempool.space/api/v1/fees/recommended"
        case .blockHeader:
            return "https://mempool.space/api/v1/blocks/"
        case .blockTransactions(let hashBlock):
            return "https://mempool.space/api/block/\(hashBlock)/txs"
        case .eachBlockSearch(let height):
            return "https://mempool.space/api/v1/blocks/\(height)"
        case .coins:
            return "https://mempool.space/api/v1/prices"
        case .coins2:
            return "https://blockchain.info/ticker"
        case .mempool:
            return "https://mempool.space/api/mempool"
        case .mempoolSize:
            return "https://mempool.space/api/v1/fees/mempool-blocks"
        case .lastBlock:
            return "https://mempool.space/api/blocks/tip/height"
        case .fullNodes:
            return "https://bitnodes.io/api/v1/snapshots/"
        case .hashrate:
            return "https://mempool.space/api/v1/mining/hashrate/3d"
        case .blockReward:
            return "https://mempool.space/api/v1/mining/reward-stats/1"
        case .difficultyAdjustment:
            return "https://mempool.space/api/v1/difficulty-adjustment"
        case .eachTransactions(let txId):
            return "https://mempool.space/api/tx/\(txId)"
        case .addressHeader(address: let address):
            return "https://mempool.space/api/address/\(address)"
        case .addressTransactions(address: let address):
            return "https://mempool.space/api/address/\(address)/txs/chain"
        case .hash(let height):
            return "https://mempool.space/api/block-height/\(height)"
        case .height(let hash):
            return "https://mempool.space/api/block/\(hash)"
        }
        
    }
    
}
