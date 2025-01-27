//
//  Blockchain.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct Blockchain: View {
    
    @State var abrirModal: Bool = false
    @State var blockHeader: Blocks?
    
    let blocks: [Blocks]
    let mempoolData: MempoolModel
    let mempoolSize: Double
    let mempoolVSize: Int
    
    var body: some View {
        VStack {
            
            HStack {
                Text(BlocksTexts.blockchain)
                    .foregroundColor(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }
            
            ScrollView(.horizontal) {
                
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 5)
                        .foregroundStyle(Color.chainBackground)
                    
                    HStack(spacing: 10) {
                        mempool
                        ForEach(blocks, id: \.self) { block in
                            
                            VStack {
                                let tamanho = formatSizeToMB(block.size)
                                
                                Text("\(block.height)").foregroundColor(Color.primaryText)
                                    .font(.callout)
                                    .bold()
                                Text("~\(Int(block.extras.medianFee)) \(Texts.satVb)").foregroundColor(Color.texts)
                                    .font(.footnote)
                                Text("\(tamanho) \(BlocksTexts.MB)").foregroundColor(Color.texts)
                                    .font(.callout)
                                Text("\(block.tx_count) \(TransactionsTexts.transacoes)").foregroundColor(Color.texts)
                                    .truncationMode(.tail)
                                    .font(.footnote)
                                Text("\(block.formatTimestamp(block.timestamp))").foregroundColor(Color.texts)
                                    .font(.footnote)
                            }
                            .padding()
                            .background(Color.backgroundBox)
                            .cornerRadius(7)
                            
                            .onTapGesture {
                                self.blockHeader = block
                                abrirModal.toggle()
                            }
                            
                        }
                    }
                }
            }.scrollIndicators(.hidden)
            
        }
        .padding(.leading)
        .sheet(isPresented: $abrirModal) {
            EachBlock(abrirModal: $abrirModal, blockHeader: $blockHeader)
                .presentationBackground(Color.background)
        }
        
    }
    
    var mempool: some View {
        VStack {
            Text(BlocksTexts.mempoolTitle)
                .font(.callout)
                .bold()
                .foregroundStyle(Color.texts)
            
            Text("\(mempoolData.count) \(TransactionsTexts.transacoes)")
                .foregroundStyle(Color.texts)
                .font(.footnote)
            
            Text("\(formatSizeToMB(mempoolSize)) \(BlocksTexts.MB)")
                .foregroundStyle(Color.primaryText)
                .font(.callout)
                .bold()
            
            Text("\(TransactionsTexts.taxaMaiusculo): \(String(format: "%.8f", mempoolFees(mempoolData.total_fee))) BTC")
                .foregroundStyle(Color.texts)
                .font(.footnote)
            
            Text("\(mempoolVSize) \(BlocksTexts.blocos)")
                .foregroundStyle(Color.texts)
                .font(.footnote)
        }
        .padding()
        .background(Color.backgroundBox)
        .cornerRadius(7)
        
    }
    
    func mempoolFees(_ totalFee: Double) -> Double {
        return totalFee / 100000000
    }
    
    func formatSizeToMB(_ size: Double) -> String {
        String(format: "%.2f", (size / 1000000))
    }
    
}

#Preview {
    Blockchain(blocks: [Blocks(id: "sds", height: 9, size: 93.2, tx_count: 23, timestamp: 293232, extras: Extras(medianFee: 9.3, pool: Pool(name: "nome")))], mempoolData: MempoolModel(count: 0, total_fee: 0), mempoolSize: 0, mempoolVSize: 0)
}
#Preview {
    return HomeView()
        .environmentObject(CurrencyViewModel())
        .environmentObject(AddManager())
}
