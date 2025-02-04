//
//  StoreKitView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 08/01/25.
//

import SwiftUI
import StoreKit

struct StoreKitView: View {
    
    @Binding var showSubscriptionView: Bool
    
    @EnvironmentObject private var store: SubscriptionStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
            VStack {
                ScrollView {
                    
                    VStack {
                        HStack{
                            Spacer()
                            Text(Texts.free)
                                .font(.title2)
                                .padding(.horizontal, 35)
                            Text(Texts.pro)
                                .font(.title2)
                        }
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        PlansView(feature: Texts.bitcoinPrice, isAvailableInFree: true, isAvailableInPro: true)
                        Divider()
                            .padding(.horizontal)
                        PlansView(feature: Texts.BlockchainExplorerAndFees, isAvailableInFree: true, isAvailableInPro: true)
                        Divider()
                            .padding(.horizontal)
                        PlansView(feature: Texts.searchTransactionsBlocksAndAddress, isAvailableInFree: true, isAvailableInPro: true)
                        Divider()
                            .padding(.horizontal)
                        PlansView(feature: Texts.halvingCountdownLabelStoreKit, isAvailableInFree: false, isAvailableInPro: true)
                        Divider()
                            .padding(.horizontal)
                        PlansView(feature: Texts.difficultAdjustment, isAvailableInFree: false, isAvailableInPro: true)
                        Divider()
                            .padding(.horizontal)
                        PlansView(feature: Texts.fullNodeHashrateAndBlockRewardLabelStoreKit, isAvailableInFree: false, isAvailableInPro: true)
                        Divider()
                            .padding(.horizontal)
                        PlansView(feature: Texts.calculator, isAvailableInFree: false, isAvailableInPro: true)
                        
                    }
                    .padding()
                    .background(Color.backgroundBox)
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                    .padding()
                    
                    ForEach(store.subscriptions) { subs in
                        VStack(alignment: .leading) {
                            Text(subs.displayName)
                                .font(.system(.title3, design: .rounded).bold())
                            
                            Text("\(subs.displayPrice) \(Texts.perMonth)")
                            
                            Button(Texts.subscribe) {
                                Task {
                                    await store.purchase(subs)
                                }
                            }
                            .tint(Color.primaryText)
                            .buttonStyle(.bordered)
                            .font(.callout.bold())
                        }
                        .padding()
                        .background(Color.backgroundBox)
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                    }
                    
                }
                .scrollIndicators(.hidden)
            }
            .background(Color.myBackground)
            .onChange(of: store.action) { action in
                if action == .successful {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                        store.reset()
                    }
                }
            }
            
            .alert(isPresented: $store.hasError, error: store.error) {}
        
            .sheetToolbar(title: Texts.bitcoinBlockPro)
        
    }
}

struct PlansView: View {
    var feature: String = ""
    var isAvailableInFree: Bool = false
    var isAvailableInPro: Bool = false
    
    var body: some View {
        HStack {
            Text(feature)
            Spacer()
            HStack(spacing: 50) {
                Image(systemName: isAvailableInFree ? "checkmark.circle.fill" : "x.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .foregroundStyle(isAvailableInFree ? .green : .red)
                
                Image(systemName: isAvailableInPro ? "checkmark.circle.fill" : "x.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .foregroundStyle(isAvailableInPro ? .green : .red)
            }
        }.padding()
        
    }
}

#Preview {
    StoreKitView(showSubscriptionView: .constant(true))
        .environmentObject(SubscriptionStore())
}
