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
}

// Donations Labels
extension Texts {
    static let scanText1 = String(localized: "Scan the Bitcoin QR Code with your bitcoin wallet to help me improving the app.")
    
    static let copy = String(localized: "Copy address")
    
    static let scanText2 = String(localized: "Scan the lightning network QR Code with your lightning wallet to help me improving the app.")
    
    static let copyInvoice = String(localized: "Copy lightning invoice")
    
    static let bitcoinAddressTitle = String(localized: "Bitcoin mainnet address")
    
    static let lightningTitle = String(localized: "Lightning network address")
}

// ToastView labels
extension Texts {
    static let copied: String = String(localized: "copied")
}

// Toolbar app labels
extension Texts {
    static let searchPlaceholder: String = String(localized: "searchPlaceholder")
    
    static let bitcoinIcone: String = "bitcoinIcone"
    
    static let titleOfTheApp: String = "Bitcoin Block Explorer"
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
