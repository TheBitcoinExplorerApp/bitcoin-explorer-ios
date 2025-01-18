//
//  BoxBlocks.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct BoxBlocks: View {
    
    @State var timestamp: String = ""
    @State var numberTransactions: Int64 = 0
    @State var blockMiner: String = ""
    @State var medianFee: Double = 0
    @State var blockSize: Double = 0
    @State var heightBlock: Int = 0
    @State var hashBlock: String = ""
    @StateObject var blockData = BlockData()
    @State var abrirModal: Bool = false
    let colunas = [GridItem(spacing: 20), GridItem()]
    
    @State private var showSubscriptionView: Bool = false
    @EnvironmentObject private var store: SubscriptionStore
    
    var body: some View {
        VStack{
            
            HStack{
                Text(BlocksTexts.blocos)
                    .foregroundColor(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }
            
            if blockData.loading {
                ProgressView().scaleEffect(1.2)
                
            } else {
                
                LazyVGrid(columns: colunas, spacing: 15) {
                    ForEach(blockData.blockDatas, id: \.self) { blocks in
                        
                        VStack{
                            let tamanho = String(format: "%.2f", (blocks.size / 1000000))
                            
                            Text("\(blocks.height)").foregroundColor(Color.primaryText)
                                .font(.callout)
                            Text("~\(Int(blocks.extras.medianFee)) \(Texts.satVb)").foregroundColor(Color.texts)
                                .font(.footnote)
                            Text("\(tamanho) \(BlocksTexts.MB)").foregroundColor(Color.texts)
                                .font(.footnote)
                            Text("\(blocks.tx_count) \(TransactionsTexts.transacoes)").foregroundColor(Color.texts)
                                .font(.footnote)
                            Text("\(blocks.formatTimestamp(blocks.timestamp))").foregroundColor(Color.texts)
                                .font(.footnote)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.backgroundBox)
                        .cornerRadius(7)
                        
                        .overlay {
                            if store.purschasedSubscriptions == false {
                                Color.backgroundBox
                                    .blur(radius: 15)
                            }
                        }
                        
                        .onTapGesture {
                            if store.purschasedSubscriptions == false {
                                showSubscriptionView.toggle()
                            } else {
                                hashBlock = blocks.id
                                heightBlock = blocks.height
                                medianFee = blocks.extras.medianFee
                                blockSize = blocks.size
                                blockMiner = blocks.extras.pool.name
                                numberTransactions = blocks.tx_count
                                timestamp = blocks.formatTimestampWithHour(blocks.timestamp)
                                
                                abrirModal.toggle()
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        //        .overlay {
        //            if showSubscriptionView {
        //                Color.black.opacity(0.8)
        //                    .ignoresSafeArea()
        //                    .transition(.opacity)
        //
        //                StoreKitView()
        //                    .transition(.move(edge: .bottom).combined(with: .opacity))
        //            }
        //        }
        
        .padding(.horizontal)
        .sheet(isPresented: $abrirModal) {
            EachBlock(timestamp: $timestamp,numberTransactions: $numberTransactions, blockMiner: $blockMiner, medianFee: $medianFee, blockSize: $blockSize, hashBlock: $hashBlock, heightBlock: $heightBlock, abrirModal: $abrirModal)
                .presentationBackground(Color.background)
        }
        .sheet(isPresented: $showSubscriptionView) {
            StoreKitView(showSubscriptionView: $showSubscriptionView)
        }
        
        .task {
            blockData.getBlockDatas(4)
        }
        
    }
}

#Preview {
    BoxBlocks().environmentObject(SubscriptionStore())
}
