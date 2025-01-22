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
    @State var abrirModal: Bool = false
    
    let blocks: [Blocks]
    
    var body: some View {
        VStack {
            
            HStack {
                Text(BlocksTexts.blocos)
                    .foregroundColor(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }
            
            ScrollView(.horizontal) {
                
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 8)
                        .foregroundStyle(Color.chainBackground)
                    
                    HStack(spacing: 10) {
                        ForEach(blocks, id: \.self) { blocks in
                            
                            VStack {
                                let tamanho = String(format: "%.2f", (blocks.size / 1000000))
                                
                                Text("\(blocks.height)").foregroundColor(Color.primaryText)
                                    .font(.callout)
                                Text("~\(Int(blocks.extras.medianFee)) \(Texts.satVb)").foregroundColor(Color.texts)
                                    .font(.footnote)
                                Text("\(tamanho) \(BlocksTexts.MB)").foregroundColor(Color.texts)
                                    .font(.callout)
                                Text("\(blocks.tx_count) \(TransactionsTexts.transacoes)").foregroundColor(Color.texts)
                                    .truncationMode(.tail)
                                    .font(.footnote)
                                Text("\(blocks.formatTimestamp(blocks.timestamp))").foregroundColor(Color.texts)
                                    .font(.footnote)
                            }
                            .padding()
                            .background(Color.backgroundBox)
                            .cornerRadius(7)
                            
                            .onTapGesture {
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
            }.scrollIndicators(.hidden)
            
        }
        .padding(.leading)
        .sheet(isPresented: $abrirModal) {
            EachBlock(timestamp: $timestamp,numberTransactions: $numberTransactions, blockMiner: $blockMiner, medianFee: $medianFee, blockSize: $blockSize, hashBlock: $hashBlock, heightBlock: $heightBlock, abrirModal: $abrirModal)
                .presentationBackground(Color.background)
        }
        
    }
}

#Preview {
    BoxBlocks(blocks: [Blocks(id: "sds", height: 9, size: 93.2, tx_count: 23, timestamp: 293232, extras: Extras(medianFee: 9.3, pool: Pool(name: "nome")))])
}
#Preview {
   return HomeView()
        .environmentObject(CurrencyComponentViewModel())
        .environmentObject(AddManager())
}
