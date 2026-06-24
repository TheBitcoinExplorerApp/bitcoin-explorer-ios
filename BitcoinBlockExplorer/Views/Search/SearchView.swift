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
        .bitcoinSearch(
            model: model,
            lastBlock: lastBlockViewModel.lastBlock,
            placement: .navigationBarDrawer(displayMode: .always)
        )
    }
}
