//
//  HashrateView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 31/01/25.
//

import SwiftUI

struct HashrateView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    var body: some View {
        VStack {
            Text(Texts.hashrate)
                .font(.body)
                .bold()
                .foregroundStyle(.texts)
            Text("\(formatHashrate(viewModel.hashRate))")
                .font(.title2)
                .foregroundStyle(.primaryText)
                .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
        }
        .task {
            viewModel.fetchHashrate()
        }
    }
    
    private func formatHashrate(_ hashrate: Double) -> String {
        let exahash = hashrate / Double.hashToExahash
        
        return String(format: "%.2f EH/s", exahash)
    }
    
}

#Preview {
    HashrateView()
        .environmentObject(BlockchainViewModel())
}
