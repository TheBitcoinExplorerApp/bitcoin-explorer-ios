//
//  SearchModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/06/26.
//

import Foundation

final class SearchModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var resultType: String?
    @Published var isInvalid: Bool = false

    @Published var addressSearch: String = ""
    @Published var abrirModalAddress: Bool = false

    @Published var idTransacaoButton: String = ""
    @Published var idTransacaoSearch: String = ""
    @Published var abrirModalTransaction: Bool = false

    @Published var abrirModalBlock: Bool = false
    let eachBlockViewModel = EachBlockSearchViewModel()

    func classifyInput(lastBlock: Int64) {
        let input = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if isBlockHeight(input, lastBlock: lastBlock) {
            eachBlockViewModel.height = Int(input)
            searchText = ""
            abrirModalBlock.toggle()
        } else if isBlockHash(input) {
            eachBlockViewModel.hash = input
            searchText = ""
            abrirModalBlock.toggle()
        } else if isValidBitcoinAddress(input) {
            addressSearch = input
            searchText = ""
            abrirModalAddress.toggle()
        } else if isValidTransactionID(input) {
            idTransacaoSearch = input
            searchText = ""
            abrirModalTransaction.toggle()
        } else {
            resultType = "invalid"
            showTemporaryError()
        }
    }

    func showTemporaryError() {
        isInvalid = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isInvalid = false
            self?.resultType = nil
            self?.searchText = ""
        }
    }

    func isBlockHeight(_ height: String, lastBlock: Int64) -> Bool {
        if let number = Int64(height), number >= 0 && number <= lastBlock {
            return true
        }
        return false
    }

    func isBlockHash(_ hash: String) -> Bool {
        let hashRegex = "^[0]{8,}[0-9a-fA-F]{56}$"
        return NSPredicate(format: "SELF MATCHES %@", hashRegex).evaluate(with: hash)
    }

    func isValidBitcoinAddress(_ address: String) -> Bool {
        let base58Regex = "^[13][1-9A-HJ-NP-Za-km-z]{25,34}$"
        let bech32Regex = "^bc1[a-z0-9]{8,87}$"

        let base58Check = NSPredicate(format: "SELF MATCHES %@", base58Regex).evaluate(with: address)
        let bech32Check = NSPredicate(format: "SELF MATCHES %@", bech32Regex).evaluate(with: address)

        return base58Check || bech32Check
    }

    func isValidTransactionID(_ txid: String) -> Bool {
        let txidRegex = "^[0-9a-fA-F]{64}$"
        return NSPredicate(format: "SELF MATCHES %@", txidRegex).evaluate(with: txid)
    }
}
