//
//  LockView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/02/25.
//

import SwiftUI

struct LockView: View {
    @State private var showSubscriptionView: Bool = false
    @EnvironmentObject private var store: SubscriptionStore
    
    var body: some View {
        ZStack {
            TransparentBlurView(removeAllFilters: false)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            
            Image(systemName: "lock.fill")
                .resizable()
                .scaledToFit()
                .padding(15)
        }
        
        .onTapGesture {
            if store.purschasedSubscriptions == false {
                showSubscriptionView.toggle()
            }
        }
        
        .sheet(isPresented: $showSubscriptionView) {
            StoreKitView(showSubscriptionView: $showSubscriptionView)
        }
    }
}

#Preview {
    LockView()
        .environmentObject(SubscriptionStore())
}
