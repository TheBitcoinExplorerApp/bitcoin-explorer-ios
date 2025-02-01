//
//  BlockRewardView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 31/01/25.
//

import SwiftUI

struct BlockRewardView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    var body: some View {
        VStack {
            Text("Recompensa último bloco")
                .font(.body)
                .bold()
                .foregroundStyle(.texts)
            VStack {
                Text("\(formatBlockRewardToString(viewModel.blockReward))")
                    .font(.title3)
                    .foregroundStyle(.texts)
                CurrencyView(rate: formatRewardOfSatsToBTC(viewModel.blockReward))
                    .foregroundStyle(Color.primaryText)
                    .font(.subheadline)
            } .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            
        }
        .task {
            viewModel.fetchBlockReward()
        }
    }
    
    private func formatBlockRewardToString(_ blockReward: Double) -> String {
        let reward = blockReward / Double.BtcInSats
        return String(format: "%.3f BTC", reward)
    }
    
    private func formatRewardOfSatsToBTC(_ blockReward: Double) -> Double {
        let reward = blockReward / Double.BtcInSats
        return reward
    }
    
}

#Preview {
    BlockRewardView()
        .environmentObject(BlockchainViewModel())
        .environmentObject(CurrencyViewModel())
}
