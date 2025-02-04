//
//  DifficultyAdjustmentView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 31/01/25.
//

import SwiftUI

struct DifficultyAdjustmentView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text(Texts.difficultAdjustment)
                    .foregroundStyle(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom, 5)
            
            VStack{
                HStack {
                    Text("\(blocksLeft(viewModel.difficultAdjustment?.progressPercent ?? 0)) \(Texts.blocos)")
                        .foregroundStyle(Color.texts)
                        .font(.subheadline)
                    Spacer()
                    Text("\(viewModel.difficultAdjustment?.remainingBlocks ?? 0) \(Texts.restante)")
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
                                .frame(width: progress * geometry.size.width, height: geometry.size.height)
                                .animation(.easeInOut, value: progress)
                        }
                    }
            }
            .padding()
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            
            .lockView()
            
        }
        .padding(.horizontal)
        
        .task {
            viewModel.fetchDifficultyAdjustment()
        }
        
        .onChange(of: viewModel.difficultAdjustment?.progressPercent) { newBlock in
            self.progress = blocksLeftInDouble(viewModel.difficultAdjustment?.progressPercent ?? 0) / Double.difficultAdjustment
        }
        
    }
    
    func blocksLeft(_ progressPercentage: Double) -> String {
        let blockLeft = ((progressPercentage * Double.difficultAdjustment) / 100)
        return String(format: "%.0f", blockLeft)
    }
    
    func blocksLeftInDouble(_ progressPercentage: Double) -> Double {
        let blockLeft = ((progressPercentage * Double.difficultAdjustment) / 100)
        return blockLeft
    }
    
}

#Preview {
    DifficultyAdjustmentView()
        .environmentObject(BlockchainViewModel())
        .environmentObject(SubscriptionStore())
}
