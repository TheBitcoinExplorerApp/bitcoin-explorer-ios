//
//  EachBlock.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 17/05/23.
//

import SwiftUI

struct EachBlock: View{
  @Binding var timestamp: String
  @Binding var numberTransactions: Int64
  @Binding var blockMiner: String
  @Binding var medianFee: Double
  @Binding var blockSize: Double
  @Binding var hashBlock: String
  @Binding var heightBlock: Int
  @Binding var abrirModal: Bool
  @StateObject var blockTransactionData = BlockTransactionsData()
  
  var largura = UIScreen.main.bounds.size.width
  
  var body: some View {
    VStack{
      ScrollView{
        
        HStack{
          Spacer()
          Text("Bloco").foregroundColor(Color("cinza")).offset(x: 15, y: 15)
          Spacer()
          Button{
            abrirModal.toggle()
          } label: {
            Circle()
              .fill()
              .foregroundColor(Color("cinza"))
              .frame(width: 30, height: 30)
              .overlay() {
                Text("X").clipShape(Circle()).font(.system(size: 20)).foregroundColor(Color("laranja"))
              }.offset(x: -10, y: 15)
          }
        }
        
        HStack{
          ZStack{
            RoundedRectangle(cornerRadius: 7).foregroundColor(Color("caixas")).frame(width: 147,height: 40)
            HStack{
              Text("Bloco").foregroundColor(Color("cinza")).font(.system(size: 15))
              Text("\(heightBlock)").foregroundColor(Color("cinza")).font(.system(size: 15))
            }
          }
          Spacer()
        }.padding()
        
        Button{
          UIPasteboard.general.string = "\(hashBlock)"
        } label: {
          
          VStack{
            HStack{
              Text("Hash").foregroundColor(Color("cinza")).font(.system(size: 15))
              Spacer()
              Text("\(String(hashBlock.prefix(25)))...").foregroundColor(Color("laranja")).font(.system(size: 15))
            }.padding()
              .background(Color("caixas")).frame(height: 40)
              .cornerRadius(7)
          }.padding(.horizontal)
            
        }
        
        VStack{
          VStack{
            HStack{
              Text("Data/Hora").foregroundColor(Color("cinza")).font(.system(size: 15))
              Spacer()
              Text("\(timestamp)").foregroundColor(Color("laranja")).font(.system(size: 15))
            }
            
            Divider().padding(.horizontal, -largura)
            
            HStack{
              let tamanho = String(format: "%.2f", (blockSize / 1000000))
              
              Text("Tamanho").foregroundColor(Color("cinza")).font(.system(size: 15))
              Spacer()
              Text("\(tamanho) MB").foregroundColor(Color("laranja")).font(.system(size: 15))
            }
            
            Divider().padding(.horizontal, -largura)
            
            HStack{
              Text("Taxa mediana").foregroundColor(Color("cinza")).font(.system(size: 15))
              Spacer()
              Text("~\(Int(medianFee)) sat/vB").foregroundColor(Color("laranja")).font(.system(size: 15))
            }
            
            Divider().padding(.horizontal, -largura)
            
            HStack{
              Text("Minerador").foregroundColor(Color("cinza")).font(.system(size: 15))
              Spacer()
              Text("\(blockMiner)").foregroundColor(Color("laranja")).font(.system(size: 15))
            }
            
          }.padding()
          .background(Color("caixas"))
          .cornerRadius(7)
        }.padding(.horizontal)
        
        HStack{
          Text("\(numberTransactions) transações").foregroundColor(Color("cinza")).font(.system(size: 15))
          Spacer()
          //          Image(systemName: "chevron.left").foregroundColor(Color("cinza"))
          //          Image(systemName: "chevron.right").foregroundColor(Color("cinza"))
        }
        .padding(.horizontal)
        .padding(.top)
        
        if blockTransactionData.loading{
          ProgressView()
        } else {
          
          ForEach(blockTransactionData.blockTransactionsData, id: \.self) { blocksT in
            
            Button{
              UIPasteboard.general.string = "\(blocksT.txid)"
            } label: {
              
              VStack{
                HStack{
                  // Id da transacao
                  Text("\(blocksT.txid)").foregroundColor(Color("laranja")).font(.system(size: 12)).lineLimit(1)
                  Spacer()
                  // data transacao
                  if let blockTimeDesembrulhado = blocksT.status.block_time, let formattedTime = blocksT.status.formatTime(blockTimeDesembrulhado) {
                    Text(formattedTime)
                      .foregroundColor(Color("cinza")).opacity(0.6)
                      .font(.system(size: 12))
                  }
                }.padding()
                  .background(Color("caixas")).cornerRadius(7)
              }.padding(.horizontal)
              
            }
  
            VStack{
              HStack{
                VStack{
                  ForEach(blocksT.vin, id: \.self) { vin in
                    if let prevoutDesembrulhado: Prevout = vin.prevout {
                      Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...").foregroundColor(Color("cinza")).font(.system(size: 12))
                      Text("\(prevoutDesembrulhado.value / 100000000) BTC").foregroundColor(Color("cinza")).font(.system(size: 12))
                    } else {
                      Text("Coinbase").foregroundColor(Color("cinza")).font(.system(size: 12))
                    }
                  }
                }
                Spacer()
                Image("setinha").foregroundColor(Color("cinza"))
                Spacer()
                VStack {
                  ForEach(blocksT.vout.indices, id: \.self) { index in
                    if let scriptpubkey_address = blocksT.vout[index].scriptpubkey_address {
                      Text("\(String(scriptpubkey_address.prefix(15)))...")
                        .foregroundColor(Color("cinza"))
                        .font(.system(size: 12))
                    } else {
                      Text("OP_RETURN")
                        .foregroundColor(Color("cinza"))
                        .font(.system(size: 12))
                    }
                    
                    Text("\(blocksT.vout[index].value / 100000000) BTC")
                      .foregroundColor(Color("cinza"))
                      .font(.system(size: 12))
                    
                  }
                }
                
              }.padding()
                .background(Color("caixas")).cornerRadius(7)
            }.padding(.horizontal)
            
            HStack {
            }.padding(.bottom, 20)
            
          }
        }
      }.scrollIndicators(.hidden)
      
    }.onAppear() {
      blockTransactionData.getEachBlocksInfo(hashBlock)
    }
    
  }
}
