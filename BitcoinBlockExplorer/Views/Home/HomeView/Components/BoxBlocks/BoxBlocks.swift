//
//  BoxBlocks.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct BoxBlocks: View {
    
    @State var abrirModal: Bool = false
    @State var blockHeader: Blocks?
 
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
                        ForEach(blocks, id: \.self) { block in
                            
                            VStack {
                                let tamanho = String(format: "%.2f", (block.size / 1000000))
                                
                                Text("\(block.height)").foregroundColor(Color.primaryText)
                                    .font(.callout)
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
}

#Preview {
    BoxBlocks(blocks: [Blocks(id: "sds", height: 9, size: 93.2, tx_count: 23, timestamp: 293232, extras: Extras(medianFee: 9.3, pool: Pool(name: "nome")))])
}
#Preview {
   return HomeView()
        .environmentObject(CurrencyComponentViewModel())
        .environmentObject(AddManager())
}
