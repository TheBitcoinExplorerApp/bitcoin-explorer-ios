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
            
            HStack {
                ForEach(store.subscriptions) { subs in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(subs.displayName)
                            .font(.system(.title3, design: .rounded).bold())
                        Text(subs.description)
                            .font(.system(.callout, design: .rounded).weight(.regular))
                    }
                    
                    Spacer()
                    
                    Button(subs.displayPrice) {
                        Task {
                            await store.purchase(subs)
                        }
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .font(.callout.bold())
                }
            }.padding(.horizontal)
            
        }
        .onChange(of: store.action) { action in
            if action == .successful {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   dismiss()
                    store.reset()
                }
            }
        }
        
        .alert(isPresented: $store.hasError, error: store.error) {}
        
    }
}

#Preview {
    StoreKitView(showSubscriptionView: .constant(true))
        .environmentObject(SubscriptionStore())
}
