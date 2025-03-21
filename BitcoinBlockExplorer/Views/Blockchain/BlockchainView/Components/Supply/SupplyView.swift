//
//  SupplyView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 13/03/25.
//

import SwiftUI

struct SupplyView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    var body: some View {
        VStack {
            Text("Circulating Supply")
                .font(.body)
                .bold()
                .foregroundStyle(.texts)
            Text("\(formatSupply(viewModel.totalSupply)) ")
                .font(.title3)
                .foregroundStyle(.primaryText)
                .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            
                .lockView()
        }
    }
    
    private func formatSupply(_ supply: Double) -> String {
        let supplyFormatted = supply / 100000000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: supplyFormatted)) ?? "0"
    }
    
}

#Preview {
    SupplyView()
        .environmentObject(BlockchainViewModel())
        .environmentObject(SubscriptionStore())
}
