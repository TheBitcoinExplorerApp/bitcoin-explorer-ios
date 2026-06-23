//
//  SearchTabView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/06/26.
//

import SwiftUI

struct SearchTabView: View {
    @ObservedObject var model: SearchModel

    @EnvironmentObject var lastBlockViewModel: LastBlockViewModel

    var body: some View {
        List {
            Section {
                guideRow(
                    icon: "number",
                    title: Texts.searchGuideBlockHeightTitle,
                    example: "870000"
                )
                guideRow(
                    icon: "number.square",
                    title: Texts.searchGuideBlockHashTitle,
                    example: "0000000000000000000123…"
                )
                guideRow(
                    icon: "person.crop.circle",
                    title: Texts.searchGuideAddressTitle,
                    example: "bc1q… / 1A1z…"
                )
                guideRow(
                    icon: "link",
                    title: Texts.searchGuideTransactionTitle,
                    example: "a1075db55d416d3ca199f55b6084e211…"
                )
            } header: {
                Text(Texts.searchGuideHeader)
            } footer: {
                if model.resultType == "invalid" {
                    Text(Texts.invalid)
                        .foregroundStyle(.red)
                }
            }
            .listRowBackground(Color.backgroundBox)
        }
        .background(Color.myBackground)
        .scrollContentBackground(.hidden)
        .bitcoinSearch(model: model, lastBlock: lastBlockViewModel.lastBlock)
    }

    private func guideRow(icon: String, title: String, example: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(Color.primaryText)
                Text(example)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SearchTabView(model: SearchModel())
        .environmentObject(LastBlockViewModel())
}
