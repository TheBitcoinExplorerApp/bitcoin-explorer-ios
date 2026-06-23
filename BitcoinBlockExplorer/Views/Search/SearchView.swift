//
//  SearchView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/02/25.
//

import SwiftUI

struct SearchView: View {

    @StateObject private var model = SearchModel()

    @EnvironmentObject var lastBlockViewModel: LastBlockViewModel

    var body: some View {
        VStack {
            if let result = model.resultType, result == "invalid" {
                Text(Texts.invalid)
                    .font(.headline)
                    .foregroundStyle(.red)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: CGFloat.cornerRadius)
                            .stroke(model.isInvalid ? Color.red : Color.clear, lineWidth: 2)
                    )
            }
        }
        .searchable(text: $model.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Texts.searchPlaceholder) {}

        .onSubmit(of: .search) {
            model.classifyInput(lastBlock: lastBlockViewModel.lastBlock)
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
