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
        
        VStack {
            List {
                Section {
                    Picker(selection: $selected, label: Text(Texts.currencyLabel)
                        .foregroundStyle(Color.texts)) {
                            
                            ForEach(0 ..< self.currencies.count, id: \.self) { index in
                                Text(self.currencies[index])
                                    .tag(index)
                                    .foregroundStyle(Color.texts)
                                
                            }
                            
                        }.onChange(of: selected) { newValue in
                            currencyViewModel.currency1 = newValue
                        }
                    
                }.listRowBackground(Color.backgroundBox)
                
                Section(Texts.support) {
                    NavigationLink {
                        DonationsView()
                    } label: {
                        Label {
                            HStack {
                                Text(Texts.donations)
                                    .foregroundStyle(Color.texts)
                            }
                        } icon: {
                            Image(systemName: "bitcoinsign")
                                .foregroundStyle(Color.primaryText)
                        }
                    }
                    
                    LabelLink(Texts.sourceCode, url: "https://github.com/TheBitcoinExplorerApp/bitcoin-explorer-ios", systemImage: "chevron.left.forwardslash.chevron.right")
                    
                    LabelLink(Texts.reportIssues, url: "https://bitcoinblockchainexplorer.atlassian.net/servicedesk/customer/portal/1", systemImage: "ladybug.fill")
                    
                }.listRowBackground(Color.backgroundBox)
                
            }
            .navigationTitle(Texts.configuracoes)
            .navigationBarTitleColor(Color.primaryText)
            .background(Color.background)
            .scrollContentBackground(.hidden)
            
            AdViewComponent()
            
        }
        .background(Color.background)
       
    }
}

#Preview {
    let vm = CurrencyComponentViewModel()
    let addManager = AddManager()
    return ConfigurationsView()
        .environmentObject(addManager)
        .environmentObject(vm)
}
