//
//  DonationsView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/03/24.
//

import SwiftUI

struct DonationsView: View {
    var body: some View {
        
        TabView {
            
            BitcoinWalletView()
            
            LightningWalletView()
            
        }.background(Color.azul)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    DonationsView()
}
