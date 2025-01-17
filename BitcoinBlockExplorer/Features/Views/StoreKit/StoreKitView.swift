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
    @EnvironmentObject private var subsStore: SubscriptionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        VStack {
            
            HStack {
                ForEach(subsStore.subscriptions) { subs in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(subs.displayName)
                            .font(.system(.title3, design: .rounded).bold())
                        Text(subs.description)
                            .font(.system(.callout, design: .rounded).weight(.regular))
                    }
                    
                    Spacer()
                    
                    Button(subs.displayPrice) {
                        Task {
                            await subsStore.purchase(subs)
                        }
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .font(.callout.bold())
                }
            }.padding(.horizontal)
            
        }
        .onChange(of: subsStore.action) { action in
            if action == .successful {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   dismiss()
                    subsStore.reset()
                }
            }
        }
        
    }
}

#Preview {
    StoreKitView(showSubscriptionView: .constant(true))
        .environmentObject(SubscriptionStore())
}
