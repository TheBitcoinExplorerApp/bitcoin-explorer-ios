//
//  BitcoinSearchModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/06/26.
//

import SwiftUI

struct BitcoinSearchModifier: ViewModifier {
    @ObservedObject var model: SearchModel
    let lastBlock: Int64

    func body(content: Content) -> some View {
        content
            .searchable(text: $model.searchText, prompt: Texts.searchPlaceholder)
            .onSubmit(of: .search) {
                model.classifyInput(lastBlock: lastBlock)
            }
            .sheet(isPresented: $model.abrirModalAddress) {
                EachAddressView(addressSearch: $model.addressSearch,
                                abrirModalAddress: $model.abrirModalAddress)
                    .presentationBackground(Color.myBackground)
            }
            .sheet(isPresented: $model.abrirModalTransaction) {
                EachTransaction(idTransacaoButton: $model.idTransacaoButton,
                                idTransacaoSearch: $model.idTransacaoSearch,
                                abrirModalTransaction: $model.abrirModalTransaction)
                    .presentationBackground(Color.myBackground)
            }
            .sheet(isPresented: $model.abrirModalBlock) {
                EachBlockSearchView(abrirModalBlock: $model.abrirModalBlock)
                    .environmentObject(model.eachBlockViewModel)
                    .presentationBackground(Color.myBackground)
            }
    }
}

extension View {
    func bitcoinSearch(model: SearchModel, lastBlock: Int64) -> some View {
        modifier(BitcoinSearchModifier(model: model, lastBlock: lastBlock))
    }
}
