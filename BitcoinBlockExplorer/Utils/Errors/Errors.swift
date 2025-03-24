//
//  Errors.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 24/03/25.
//

enum Errors {
    case fees, blockHeader, mempoolData, mempoolSize, fullNodes, hashrate, blockReward, difficultyAdjustment, blockchainSupply, addressHeader, addressTransactions, eachBlockHeaderSearch, blockTransactionsSearch, eachTransaction, blockTransactions, lastBlock
    
    var errorDescription: String {
        switch self {
        case .fees:
            return "Fees could not be retrieved."
        case .blockHeader:
            return "Block header could not be retrieved."
        case .mempoolData:
            return "Mempool data could not be retrieved."
        case .mempoolSize:
            return "Mempool size could not be retrieved."
        case .fullNodes:
            return "Full nodes could not be retrieved."
        case .hashrate:
            return "Hashrate could not be retrieved."
        case .blockReward:
            return "Block reward could not be retrieved."
        case .difficultyAdjustment:
            return "Difficulty adjustment could not be retrieved."
        case .blockchainSupply:
            return "Blockchain supply could not be retrieved."
        case .addressHeader:
            return "Address header could not be retrieved."
        case .addressTransactions:
            return "Address transactions could not be retrieved."
        case .eachBlockHeaderSearch:
            return "Each block header search could not be retrieved."
        case .blockTransactionsSearch:
            return "Block transactions search could not be retrieved."
        case .eachTransaction:
            return "Each transaction could not be retrieved."
        case .blockTransactions:
            return "Block transactions could not be retrieved."
        case .lastBlock:
            return "Last block could not be retrieved."
        }
    }
}
