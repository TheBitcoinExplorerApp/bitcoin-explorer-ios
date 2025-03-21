//
//  FullNodesView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 30/01/25.
//

import SwiftUI

struct FullNodesView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    var body: some View {
        VStack {
            Text(Texts.fullNode)
                .font(.body)
                .bold()
                .foregroundStyle(.texts)
            Text("\(viewModel.totalFullNodes)")
                .font(.title3)
                .foregroundStyle(.primaryText)
                .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            
                .lockView()
        }
        .task {
            viewModel.getFullNodes()
        }
    }
}

#Preview {
    FullNodesView()
        .environmentObject(BlockchainViewModel())
        .environmentObject(SubscriptionStore())
}
