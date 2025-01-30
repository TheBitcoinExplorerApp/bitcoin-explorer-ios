//
//  HalvingView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 30/01/25.
//

import SwiftUI

struct HalvingView: View {
    let viewModel: BlockchainViewModel
    
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
                Text("The halving countdown is finished!")
            } else {
                GeometryReader { geometry in
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
       
                        RoundedRectangle(cornerRadius: 7)
                            .frame(height: 25)
                            .foregroundStyle(Color.background)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color.primaryText)
                                    .frame(width: progress * geometry.size.width, height: 25)
                                    .animation(.easeInOut(duration: 1), value: progress)
                            }
                        
                    }
                    .padding()
                    .background(Color.backgroundBox)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                }
              
            }
        }
        .padding()
    
        .onChange(of: lastBlockViewModel.lastBlock) { newBlock in
            self.progress = viewModel.getProgress(newBlock)
        }
        
    }
    
 
}

#Preview {
    HalvingView(viewModel: BlockchainViewModel())
        .environmentObject(LastBlockViewModel())
}
