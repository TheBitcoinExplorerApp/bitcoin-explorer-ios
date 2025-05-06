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
            return Texts.feesError
        case .blockHeader:
            return Texts.blockHeaderError
        case .mempoolData:
            return Texts.mempoolDataError
        case .mempoolSize:
            return Texts.mempoolSizeError
        case .fullNodes:
            return Texts.fullNodesError
        case .hashrate:
            return Texts.hashrateError
        case .blockReward:
            return Texts.blockRewardError
        case .difficultyAdjustment:
            return Texts.difficultyAdjustmentError
        case .blockchainSupply:
            return Texts.blockchainSupplyError
        case .addressHeader:
            return Texts.addressHeaderError
        case .addressTransactions:
            return Texts.addressTransactionsError
        case .eachBlockHeaderSearch:
            return Texts.eachBlockHeaderSearchError
        case .blockTransactionsSearch:
            return Texts.blockTransactionsError
        case .eachTransaction:
            return Texts.eachTransactionError
        case .blockTransactions:
            return Texts.blockTransactionsError
        case .lastBlock:
            return Texts.lastBlockError
        }
    }
}
