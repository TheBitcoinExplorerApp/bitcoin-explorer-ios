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
                
                VStack {
                    NavigationLink {
                        HalvingSpecificView()
                    } label: {
                        
                        HStack {
                            VStack{
                                HStack {
                                    Text("\(viewModel.getNumberBlocksAfterLastHalving(lastBlockViewModel.lastBlock)) \(Texts.blocos)")
                                        .foregroundStyle(Color.texts)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(viewModel.getNumberBlocksLeftNextHalving()) \(Texts.restante)")
                                        .foregroundStyle(Color.texts)
                                        .font(.subheadline)
                                }
                                
                                RoundedRectangle(cornerRadius: CGFloat.cornerRadius)
                                    .frame(height: 25)
                                    .foregroundStyle(Color.myBackground)
                                    .overlay(alignment: .leading) {
                                        GeometryReader { geometry in
                                            RoundedRectangle(cornerRadius: CGFloat.cornerRadius)
                                                .fill(Color.primaryText)
                                                .frame(width: progress * geometry.size.width, height: 25)
                                                .animation(.easeInOut, value: progress)
                                        }
                                    }
                                
                                HStack {
                                    Text("\(progress * 100, specifier: "%.1f")%")
                                        .foregroundStyle(Color.texts)
                                        .font(.caption2)
                                    Spacer()
                                }
                            }
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 10, height: 15)
                                .foregroundStyle(Color.gray)
                                .padding(.leading)
                        }
                    }
                    
                }
                .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                
                .lockView()
                
            }
        }
        .padding()
        .onChange(of: lastBlockViewModel.lastBlock) { newBlock in
            self.progress = viewModel.getProgress(newBlock)
        }
        
        .task {
            lastBlockViewModel.fetchLastBlock()
        }
        
    }
}

#Preview {
    HalvingView()
        .environmentObject(LastBlockViewModel())
        .environmentObject(BlockchainViewModel())
        .environmentObject(SubscriptionStore())
}
