//
//  MempoolBlocksView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct MempoolBlocksView: View {
    
    @State var abrirModal: Bool = false
    @State var blockHeader: Block?
    
    @EnvironmentObject var viewModel: BlockchainViewModel
    
    @State private var isAnimating = false
    
    @State private var startOffset: CGFloat = -1.0
    
    var body: some View {
        VStack {
            HStack {
                Text(Texts.blockchain)
                    .foregroundColor(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }.padding(.leading)
            
            ScrollView(.horizontal) {
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 5)
                        .foregroundStyle(Color.chainBackground)
                    
                    HStack(spacing: 10) {
                        mempool
                        ForEach(viewModel.blockHeaderData, id: \.self) { block in
                            
                            VStack {
                                let tamanho = formatSizeToMB(block.size)
                                
                                Text("\(block.height)")
                                    .foregroundColor(Color.primaryText)
                                    .font(.callout)
                                    .bold()
                                Text("~\(Int(block.extras.medianFee)) \(Texts.satVb)")
                                    .foregroundColor(Color.texts)
                                    .font(.footnote)
                                Text("\(tamanho) \(Texts.MB)")
                                    .foregroundColor(Color.texts)
                                    .font(.callout)
                                Text("\(block.tx_count) \(Texts.transacoes)")
                                    .foregroundColor(Color.texts)
                                    .truncationMode(.tail)
                                    .font(.footnote)
                                Text("\(block.formatTimestamp(block.timestamp))").foregroundColor(Color.texts)
                                    .font(.footnote)
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .frame(width: 10, height: 5)
                            }
                            .padding()
                            .background(Color.backgroundBox)
                            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                            .onTapGesture {
                                self.blockHeader = block
                                abrirModal.toggle()
                            }
                            
                        }
                    }
                }.padding(.leading)
            }.scrollIndicators(.hidden)
            
        }
        .sheet(isPresented: $abrirModal) {
            EachBlock(abrirModal: $abrirModal, blockHeader: $blockHeader)
                .presentationBackground(Color.myBackground)
        }
    }
    
    var mempool: some View {
        VStack {
            Text(Texts.mempoolTitle)
                .font(.callout)
                .bold()
                .foregroundStyle(Color.texts)
            
            Text("\(viewModel.mempoolData?.count ?? 0) \(Texts.transacoes)")
                .foregroundStyle(Color.texts)
                .font(.footnote)
            
            Text("\(formatSizeToMB(viewModel.getTotalMempoolSize(viewModel.mempoolSize))) \(Texts.MB)")
                .foregroundStyle(Color.primaryText)
                .font(.callout)
                .bold()
            
            Text("\(Texts.taxaMaiusculo): \(String(format: "%.8f", mempoolFees(viewModel.mempoolData?.total_fee ?? 0))) BTC")
                .foregroundStyle(Color.texts)
                .font(.footnote)
            
            Text("\(viewModel.getTotalMempoolBlocks(viewModel.mempoolSize)) \(Texts.blocos)")
                .foregroundStyle(Color.texts)
                .font(.footnote)
        }
        .padding()
        .background(content: {
            Color.backgroundBox
                .ignoresSafeArea()
            
            // Gradiente animado
            LinearGradient(
                colors: [.clear, .primaryText.opacity(0.25), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 150) // Define a largura da linha animada
            .offset(x: UIScreen.main.bounds.width * startOffset)
            .animation(
                Animation.linear(duration: 2.5)
                    .repeatForever(autoreverses: false),
                value: startOffset
            )
        })
        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
        
        .onAppear {
            startOffset = 1.5 // Move a linha para a direita
        }
    }
    
    func mempoolFees(_ totalFee: Double) -> Double {
        return totalFee / Double.BtcInSats
    }
    
    func formatSizeToMB(_ size: Double) -> String {
        String(format: "%.2f", (size / Double.bytesToMB))
    }
    
}

#Preview {
    MempoolBlocksView()
        .environmentObject(BlockchainViewModel())
}
#Preview {
    return BlockchainView()
        .environmentObject(CurrencyViewModel())
        .environmentObject(AddManager())
        .environmentObject(LastBlockViewModel())
        .environmentObject(NetworkMonitor())
        .environmentObject(BlockchainViewModel())
        .environmentObject(SubscriptionStore())
}
