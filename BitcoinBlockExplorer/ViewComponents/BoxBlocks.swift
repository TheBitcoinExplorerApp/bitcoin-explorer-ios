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
  
  var body: some View {
    VStack{
      
      HStack{
        Text("Blocos").foregroundColor(Color("cinza")).bold().font(.system(size: 17))
        Spacer()
      }
      
      if blockData.loading {
        ProgressView()
      } else {
        
        LazyVGrid(columns: colunas, spacing: 15) {
          ForEach(blockData.blockDatas, id: \.self) { blocks in
            
            Button{
              abrirModal.toggle()
            } label: {
              
              VStack{
                let tamanho = String(format: "%.2f", (blocks.size / 1000000))
                
                Text("\(blocks.height)").foregroundColor(Color("laranja")).font(.system(size: 15))
                Text("~\(Int(blocks.extras.medianFee)) sat/vB").foregroundColor(Color("cinza")).font(.system(size: 12))
                Text("\(tamanho) MB").foregroundColor(Color("cinza")).font(.system(size: 12))
                Text("\(blocks.tx_count) transações").foregroundColor(Color("cinza")).font(.system(size: 12))
                Text("\(blocks.formatTimestamp(blocks.timestamp))").foregroundColor(Color("cinza")).font(.system(size: 12))
              }.padding(.vertical)
                .frame(maxWidth: .infinity, maxHeight: 109)
              .background(Color("caixas"))
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
      }
      
    }.padding(.horizontal)
    .sheet(isPresented: $abrirModal) {
      EachBlock(timestamp: $timestamp,numberTransactions: $numberTransactions, blockMiner: $blockMiner, medianFee: $medianFee, blockSize: $blockSize, hashBlock: $hashBlock, heightBlock: $heightBlock, abrirModal: $abrirModal)
        .presentationBackground(Color("azul"))
    }
    .onAppear() {
      blockData.getBlockDatas(4)
    }
    
  }
}

struct BoxBlocks_Previews: PreviewProvider {
  static var previews: some View {
    BoxBlocks()
  }
}
