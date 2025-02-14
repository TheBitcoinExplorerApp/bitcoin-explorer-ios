//
//  ConfigurationsView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct ConfigurationsView: View {
    
    @EnvironmentObject var store: SubscriptionStore
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State private var showSubscriptionView: Bool = false
    
    var body: some View {
        
        VStack {
            List {
                Section {
                    CurrencyPickerComponent()
                }.listRowBackground(Color.backgroundBox)
                
                Section(Texts.support) {
                    
                    LabelLink(Texts.sourceCode, url: "https://github.com/TheBitcoinExplorerApp/bitcoin-explorer-ios", systemImage: "chevron.left.forwardslash.chevron.right")
                    
                    LabelLink(Texts.reportIssues, url: "https://bitcoinblockchainexplorer.atlassian.net/servicedesk/customer/portal/1", systemImage: "ladybug.fill")
                    
                    LabelLink(Texts.privacyLabel, url: "https://sites.google.com/view/bitcoinblockchainexplorer/in%C3%ADcio", systemImage: "lock.document")
                    
                    LabelLink(Texts.termsLabel, url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/", systemImage: "network.badge.shield.half.filled")
                    
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
                
                Text(Texts.informativeLabel)
                    .font(.footnote)
                    .foregroundStyle(Color.texts)
                    .listRowBackground(Color.clear)
                
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
