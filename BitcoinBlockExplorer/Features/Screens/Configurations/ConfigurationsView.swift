//
//  ConfigurationsView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct ConfigurationsView: View {
    
    @AppStorage("selected") var selected = 0
    
    @EnvironmentObject var currencyViewModel:  CurrencyComponentViewModel
    
    let currencies = ["🇺🇸 USD", "🇪🇺 EUR", "🇬🇧 GBP", "🇨🇦 CAD", "🇨🇭 CHF", "🇦🇺 AUD", "🇯🇵 JPY", "🇧🇷 BRL", "🇨🇳 CNY"]
    
    var body: some View {
        
        NavigationStack {
            
            List {
                Section {
                    Picker(selection: $selected, label: Text(Texts.currencyLabel)
                        .foregroundStyle(.white)) {
                            
                            ForEach(0 ..< self.currencies.count, id: \.self) { index in
                                Text(self.currencies[index]).tag(index)
                            }
                            
                        }.onChange(of: selected) { newValue in
                            currencyViewModel.currency1 = newValue
                        }
                    
                }.listRowBackground(Color.caixas)
                
                Section(Texts.support) {
                    NavigationLink {
                        DonationsView()
                    } label: {
                        Label {
                            HStack {
                                Text(Texts.donations)
                                    .foregroundStyle(.white)
                            }
                        } icon: {
                            Image(systemName: "bitcoinsign")
                        }
                    }
                    
                    LabelLink(Texts.sourceCode, url: "https://github.com/TheBitcoinExplorerApp/bitcoin-explorer-ios", systemImage: "chevron.left.forwardslash.chevron.right")
                    
                    LabelLink(Texts.reportIssues, url: "https://github.com/TheBitcoinExplorerApp/bitcoin-explorer-ios/issues", systemImage: "ladybug.fill")
                    
                }.listRowBackground(Color.caixas)
                
            }
            
            .navigationTitle(Texts.configuracoes)
            .navigationBarTitleColor(Color.laranja)
            .background(Color.azul)
            .scrollContentBackground(.hidden)
            
        }
        
    }
}

#Preview {
    ConfigurationsView()
}
