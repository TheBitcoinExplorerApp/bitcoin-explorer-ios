//
//  Texts.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 14/02/24.
//

import Foundation

// General labels
struct Texts {
    static let satVb: String = String(localized: "sat/VB")
    
    static let sat: String = String(localized: "sat")
    
    static let blockchain: String = String(localized: "blockchain")
    
    static let search: String = String(localized: "search")
    
    static let calculator: String = String(localized: "calculator")
    
    static let invalid: String = String(localized: "invalid")
    
    static let Sats: String = String(localized: "Sats")
}

// Fees
extension Texts {
    static let taxasDeTransacao: String = String(localized: "taxasDeTransacao")
    
    static let baixaPrioridade: String = String(localized: "baixaPrioridade")
    
    static let mediaPrioridade: String = String(localized: "mediaPrioridade")
    
    static let altaPrioridade: String = String(localized: "altaPrioridade")
}

// Bitcoin Price
extension Texts {
    static let bitcoinPrice: String = String(localized: "bitcoinPrice")
}

// ConfigurationsView labels
extension Texts {
    static let configuracoes: String = String(localized: "configuracoes")
    
    static let support: String = String(localized: "support")
    
    static let donations: String = String(localized: "donations")
    
    static let sourceCode: String = String(localized: "sourceCode")
    
    static let reportIssues: String = String(localized: "reportIssues")
    
    static let currencyLabel: String = String(localized: "currencyLabel")
    
    static let informativeLabel: String = String(localized: "informativeLabel")
    
    static let privacyLabel: String = String(localized: "privacyLabel")
    
    static let termsLabel: String = String(localized: "termsLabel")
}

// ToastView labels
extension Texts {
    static let copied: String = String(localized: "copied")
}

// Toolbar app labels
extension Texts {
    static let searchPlaceholder: String = String(localized: "searchPlaceholder")
    
    static let bitcoinIcone: String = "bitcoinIcone"
    
    static let titleOfTheApp: String = String(localized: "titleOfTheApp")
}

// Blocks labels
extension Texts {
    static let blocoMaiusculo: String = String(localized: "blocoMaiusculo")
    
    static let MB: String = "MB"
    
    static let hash: String = String(localized: "hash")
    
    static let dataEHora: String = String(localized: "data/hora")
    
    static let tamanhoMaiusculo: String = String(localized: "tamanhoMaiusculo")
    
    static let taxaMediana: String = String(localized: "taxaMediana")
    
    static let minerador: String = String(localized: "minerador")
    
    static let mempoolTitle: String = String(localized: "mempoolTitle")
    
    static let blocos: String = String(localized: "blocos")
}

// Transactions labels
extension Texts {
    static let setinha: String = "setinha"
    
    static let transacoesMaiusculo: String = String(localized: "Transacoes")
    
    static let transacoes: String = String(localized: "transacoes")
    
    static let transacaoMaiusculo: String = String(localized: "transacaoMaiusculo")
    
    static let idTransacao: String = String(localized: "idTransacao")
    
    static let valorMaiusculo: String = String(localized: "valorMaiusculo")
    
    static let taxaMaiusculo: String = String(localized: "taxaMaiusculo")
    
    static let coinbase: String = String(localized: "coinbase")
    
    static let opReturn: String = "OP_RETURN"
    
    static let naoEncontrado: String = String(localized: "naoEncontrado")
    
    static let confirmacoes: String = String(localized: "confirmacoes")
    
    static let confirmacao: String = String(localized: "confirmacao")
    
    static let naoConfirmada: String = String(localized: "naoConfirmada")
    
    static let aguardandoConfirmacao: String = String(localized: "aguardandoConfirmacao")
    
    static let entradasESaidas: String = String(localized: "entradasESaidas")
}

// Addresses labels
extension Texts {
    static let enderecoMaiusculo: String = String(localized: "enderecoMaiusculo")
    
    static let totalRecebido: String = String(localized: "totalRecebido")
    
    static let totalEnviado: String = String(localized: "totalEnviado")
    
    static let saldo: String = String(localized: "saldo")
}

// Halving labels
extension Texts {
    static let halving: String = String(localized: "Halving")
    
    static let restante: String = String(localized: "restante")
    
    static let halvingCountdownFinished: String = String(localized: "halvingCountdownFinished")
    
    static let halvings: String = String(localized: "halvings")
    
    static let newBlockReward: String = String(localized: "newBlockReward")
    
    static let atHeight: String = String(localized: "atHeight")
    
    static let previousAndUpcoming: String = String(localized: "previousAndUpcoming")
    
    static let assumedBlockInterval: String = String(localized: "assumedBlockInterval")
    
    static let estimatedDate: String = String(localized: "estimatedDate")
    
    static let nextBlockReward: String = String(localized: "nextBlockReward")
    
    static let currentBlockReward: String = String(localized: "currentBlockReward")
    
    static let nextHalvingAtHeight: String = String(localized: "nextHalvingAtHeight")
}

// Full node label
extension Texts {
    static let fullNode: String = String(localized: "fullNode")
}

// Hashrate
extension Texts {
    static let hashrate: String = String(localized: "hashrate")
}

// Block Reward
extension Texts {
    static let blockReward: String = String(localized: "blockReward")
}

// Difficult Adjustment
extension Texts {
    static let difficultAdjustment: String = String(localized: "difficultAdjustment")
}

// Internet connection Label
extension Texts {
    static let internetConnectionLabel: String = String(localized: "internetConnectionLabel")
}

// Error Alert
extension Texts {
    static let errorMessage: String = String(localized: "errorMessage")
}

// Subscribe View
extension Texts {
    static let free: String = String(localized: "free")
    
    static let pro: String = String(localized: "pro")
    
    static let BlockchainExplorerAndFees: String = String(localized: "BlockchainExplorerAndFees")
    
    static let searchTransactionsBlocksAndAddress: String = String(localized: "searchTransactionsBlocksAndAddress")
    
    static let halvingCountdownLabelStoreKit: String = String(localized: "halvingCountdownLabelStoreKit")
    
    static let fullNodeHashrateAndBlockRewardLabelStoreKit: String = String(localized: "fullNodeHashrateAndBlockRewardLabelStoreKit")
    
    static let perMonth: String = String(localized: "perMonth")
    
    static let subscribe: String = String(localized: "subscribe")
    
    static let bitcoinBlockPro: String = String(localized: "bitcoinBlockPro")
    
    static let noAds: String = String(localized: "noAds")
    
    static let proAccess: String = String(localized: "proAccess")
    
    static let youArePro: String = String(localized: "youArePro")
}

// Calculator
extension Texts {
    static let beProCalculatorLabel: String = String(localized: "beProCalculatorLabel")
    
    static let dismissKeyboard: String = String(localized: "dismissKeyboard")
}

// Circulating Supply
extension Texts {
    static let circulatingSupply: String = String(localized: "circulatingSupply")
}

// Errors
extension Texts {
    static let feesError: String = String(localized: "feesError")
    static let blockHeaderError: String = String(localized: "blockHeaderError")
    static let mempoolDataError: String = String(localized: "mempoolDataError")
    static let mempoolSizeError: String = String(localized: "mempoolSizeError")
    static let fullNodesError: String = String(localized: "fullNodesError")
    static let hashrateError: String = String(localized: "hashrateError")
    static let blockRewardError: String = String(localized: "blockRewardError")
    static let difficultyAdjustmentError: String = String(localized: "difficultyAdjustmentError")
    static let blockchainSupplyError: String = String(localized: "blockchainSupplyError")
    static let addressHeaderError: String = String(localized: "addressHeaderError")
    static let addressTransactionsError: String = String(localized: "addressTransactionsError")
    static let eachBlockHeaderSearchError: String = String(localized: "eachBlockHeaderSearchError")
    static let blockTransactionsSearchError: String = String(localized: "blockTransactionsSearchError")
    static let eachTransactionError: String = String(localized: "eachTransactionError")
    static let blockTransactionsError: String = String(localized: "blockTransactionsError")
    static let lastBlockError: String = String(localized: "lastBlockError")
}
