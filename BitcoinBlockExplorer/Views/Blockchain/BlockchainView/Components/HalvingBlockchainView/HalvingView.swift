//
//  HalvingView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 30/01/25.
//

import SwiftUI

struct HalvingView: View {
    
    @EnvironmentObject var viewModel: BlockchainViewModel
    @EnvironmentObject var lastBlockViewModel: LastBlockViewModel
    
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text(Texts.halving)
                    .foregroundStyle(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom, 5)
            
            if viewModel.hasFinishedHalving {
                Text(Texts.halvingCountdownFinished)
                    .font(.title2)
                    .foregroundStyle(Color.primaryText)
            } else {
                VStack{
                    HStack {
                        Text("\(viewModel.getNumberBlocksAfterLastHalving(6930000)) \(Texts.blocos)")
                            .foregroundStyle(Color.texts)
                            .font(.subheadline)
                        Spacer()
                        Text("\(viewModel.getNumberBlocksLeftNextHalving()) \(Texts.restante)")
                            .foregroundStyle(Color.texts)
                            .font(.subheadline)
                    }
                    
                    RoundedRectangle(cornerRadius: CGFloat.cornerRadius)
                        .frame(height: 25)
                        .foregroundStyle(Color.background)
                        .overlay(alignment: .leading) {
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: CGFloat.cornerRadius)
                                    .fill(Color.primaryText)
                                    .frame(width: progress * geometry.size.width, height: 25)
                                    .animation(.easeInOut, value: progress)
                            }
                        }
                }
                .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            }
            
        }
        .padding()
        .onChange(of: lastBlockViewModel.lastBlock) { newBlock in
            self.progress = viewModel.getProgress(newBlock)
            
        }
        
    }
}

#Preview {
    HalvingView()
        .environmentObject(LastBlockViewModel())
        .environmentObject(BlockchainViewModel())
}
