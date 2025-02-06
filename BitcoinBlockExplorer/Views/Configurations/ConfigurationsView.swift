//
//  ConfigurationsView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct ConfigurationsView: View {
    
    @AppStorage("selected") var selected = 0
    
    @EnvironmentObject var currencyViewModel:  CurrencyViewModel
    @EnvironmentObject var store: SubscriptionStore
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State private var showSubscriptionView: Bool = false
    
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
                            currencyViewModel.currency = newValue
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
                
                if networkMonitor.isConnected {
                    Section {
                        HStack {
                            if store.purschasedSubscriptions == false {
                                Text(Texts.proAccess)
                                    .foregroundStyle(Color.texts)
                                Spacer()
                                Button {
                                    showSubscriptionView.toggle()
                                } label: {
                                    Text(Texts.subscribe)
                                        .font(.headline)
                                        .bold()
                                }
                                .tint(Color.primaryText)
                                .buttonStyle(.bordered)
                            } else {
                                Text(Texts.youArePro)
                                    .foregroundStyle(Color.texts)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 20)
                                    .foregroundStyle(.green)
                            }
                        }
                    }.listRowBackground(Color.backgroundBox)
                }
                
            }
            .navigationTitle(Texts.configuracoes)
            .navigationBarTitleColor(Color.primaryText)
            .background(Color.myBackground)
            .scrollContentBackground(.hidden)
            
            AdViewComponent()
            
        }
        .background(Color.myBackground)
        
        .sheet(isPresented: $showSubscriptionView) {
            StoreKitView(showSubscriptionView: $showSubscriptionView)
        }
        
    }
}

#Preview {
    return ConfigurationsView()
        .environmentObject(AddManager())
        .environmentObject(CurrencyViewModel())
        .environmentObject(SubscriptionStore())
        .environmentObject(NetworkMonitor())
}
