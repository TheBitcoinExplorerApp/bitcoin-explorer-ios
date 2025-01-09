//
//  StoreKitView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 08/01/25.
//

import SwiftUI
import StoreKit

struct StoreKitView: View {
    
    @State private var myProduct: Product?
    
    var body: some View {
        VStack {
            Text(myProduct?.displayName ?? "")
            Text(myProduct?.description ?? "")
            Text(myProduct?.displayPrice ?? "")
        }
        .task {
            myProduct = try? await Product.products(for: [ "VictorHugoPachecoAraujo.BitcoinBlockExplorer.bitcoinData"]).first
        }
    }
}

#Preview {
    StoreKitView()
}
