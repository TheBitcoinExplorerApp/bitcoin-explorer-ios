//
//  SearchView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/02/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var resultType: String?
    @State private var isInvalid = false
    
//    @State var abrirModal: Bool = false
    
    @State var addressSearch: String = ""
    @State var idTransacaoSearch: String = ""
    @State var abrirModalAddress: Bool = false
    @State var abrirModalTransaction: Bool = false
    @State var idTransacaoButton: String = ""

    @EnvironmentObject var viewModel: BlockchainViewModel
    @EnvironmentObject var lastBlockViewModel: LastBlockViewModel
    
    var body: some View {
        VStack {
            if let result = resultType, result == "invalid" {
                Text(Texts.invalid)
                    .font(.headline)
                    .foregroundStyle(.red)
                    .padding()
                    .transition(.opacity)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Texts.searchPlaceholder) {}
        
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 2)
                .animation(.easeInOut(duration: 0.3), value: isInvalid)
        )
        
        .onSubmit(of: .search) {
            classifyInput()
        }
        
        .sheet(isPresented: $abrirModalAddress ) {
            EachAddressView(addressSearch: $addressSearch, abrirModalAddress: $abrirModalAddress)
                .presentationBackground(Color.myBackground)
        }

        .sheet(isPresented: $abrirModalTransaction) {
            EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction)
                .presentationBackground(Color.myBackground)
        }
        
//        .sheet(isPresented: $abrirModal) {
//            EachBlock(abrirModal: $abrirModal)
//                .presentationBackground(Color.myBackground)
//        }
        
    }

    func classifyInput() {
        let input = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if isBlockHeight(input) {
            resultType = input
        } else if isBlockHash(input) {
            resultType = input
        } else if isValidBitcoinAddress(input) {
            addressSearch = input
            abrirModalAddress.toggle()
        } else if isValidTransactionID(input) {
            idTransacaoSearch = input
            abrirModalTransaction.toggle()
        } else {
            resultType = "invalid"
            showTemporaryError()
        }
    }
    
    func showTemporaryError() {
        isInvalid = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isInvalid = false
            resultType = nil
            searchText = ""
        }
    }

    func isBlockHeight(_ height: String) -> Bool {
        if let number = Int(height), number >= 0 && number <= lastBlockViewModel.lastBlock {
            return true
        }
        return false
    }

    func isBlockHash(_ hash: String) -> Bool {
        let hashRegex = "^[0]{8,}[0-9a-fA-F]{56}$"  // Deve começar com 8 ou mais zeros
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
