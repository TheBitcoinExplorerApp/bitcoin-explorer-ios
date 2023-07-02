//
//  EachTransaction.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

//TODO: tornar essa tela totalmente responsiva
import SwiftUI

struct EachTransaction: View {
  @StateObject var transaction = EachTransactionData()
  @StateObject var lastBlock = LastBlockData()
  @Binding var idTransacaoButton: String
  @Binding var idTransacaoSearch: String
  @Binding var abrirModalTransaction: Bool
  
  var largura = UIScreen.main.bounds.size.width
  
  var body: some View {
    
    VStack{
      ScrollView{
        
        HStack{
          Spacer()
          Text("Transação").foregroundColor(Color("cinza")).offset(x: 15, y: 15)
          Spacer()
          Button{
            abrirModalTransaction.toggle()
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
        }.padding(.bottom, 30)
        
        if transaction.erro == nil {
          Button {
            UIPasteboard.general.string = "\(idTransacaoButton) \(idTransacaoSearch)"
          } label: {
            
            VStack{
              HStack{
                Text("Transação").foregroundColor(Color("cinza")).font(.system(size: 15))
                Spacer()
                if(idTransacaoButton == "") {
                  Text("\(String(idTransacaoSearch.prefix(25)))...").foregroundColor(Color("laranja")).font(.system(size: 15))
                } else {
                  Text("\(String(idTransacaoButton.prefix(25)))...").foregroundColor(Color("laranja")).font(.system(size: 15))
                }
              }.padding()
                .background(Color("caixas"))
                .frame(maxHeight: 40)
                .cornerRadius(7)
            }.padding(.horizontal)
            
          }
          
        } else {
          Text("Não encontrado").font(.system(size: 28)).foregroundColor(Color("cinza"))
        }
        
        if transaction.loading{
          ProgressView()
        } else {
          
          ForEach(transaction.eachTransactionDatas, id: \.self) { transactions in
            
            HStack{
              
              if let blockHeightDesembrulhado = transactions.status.block_height {
                ZStack{
                  RoundedRectangle(cornerRadius: 7).foregroundColor(Color("caixas")).frame(width: 135, height: 40)
                  HStack{
                    Text("Bloco").foregroundColor(Color("cinza")).font(.system(size: 15))
                    Text("\(blockHeightDesembrulhado)").foregroundColor(Color("cinza")).font(.system(size: 15))
                  }
                }.padding()
              } else {
                
              }
              
              Spacer()
              
              ZStack{
                RoundedRectangle(cornerRadius: 7).foregroundColor(Color("caixas")).frame(width: 170, height: 40)
                HStack{
                  if(transactions.status.confirmed) {
                    let confirmacoes = lastBlock.lastBlock - transactions.status.block_height! + 1
                    let mensagem = confirmacoes > 1 ? "confirmações" : "confirmação"
                    Text("\(String(confirmacoes)) \(mensagem)").foregroundColor(Color("cinza")).font(.system(size: 15))
                  } else {
                    Text("Não confirmada").foregroundColor(Color("cinza")).font(.system(size: 15))
                  }
                }
              }.padding()
              
            }
            
            VStack{
              VStack{
                HStack{
                  Text("Data/Hora").foregroundColor(Color("cinza")).font(.system(size: 15))
                  Spacer()
                  if let blockTimeDesembrulhado = transactions.status.block_time, let formattedTime = transactions.status.formatTime(blockTimeDesembrulhado) {
                    Text("\(formattedTime)").foregroundColor(Color("laranja")).font(.system(size: 15))
                  } else {
                    Text("Aguardando confirmação").foregroundColor(Color("laranja")).font(.system(size: 15))
                  }
                }
                
                Divider().padding(.horizontal, -largura)
                
                HStack{
                  Text("Tamanho").foregroundColor(Color("cinza")).font(.system(size: 15))
                  Spacer()
                  Text("\(transactions.size) B").foregroundColor(Color("laranja")).font(.system(size: 15))
                }
                
                Divider().padding(.horizontal, -largura)
                
                HStack{
                  Text("Taxa ").foregroundColor(Color("cinza")).font(.system(size: 15))
                  Spacer()
                  Text("\(transactions.fee / 100000000) BTC").foregroundColor(Color("laranja")).font(.system(size: 15))
                }
                
              }.padding()
                .background(Color("caixas"))
                .cornerRadius(7)
            }.padding(.horizontal)
            
            HStack{
              Text("Entradas e Saídas").foregroundColor(Color("cinza")).font(.system(size: 15))
              Spacer()
            }.padding(.top)
              .padding(.horizontal)
            
            VStack{
              HStack{
                
                VStack{
                  ForEach(transactions.vin, id: \.self) { vin in
                    if let prevoutDesembrulhado: Prevout = vin.prevout {
                      Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...").foregroundColor(Color("laranja")).font(.system(size: 12))
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
                  ForEach(transactions.vout.indices, id: \.self) { index in
                    if let scriptpubkey_address = transactions.vout[index].scriptpubkey_address {
                      Text("\(String(scriptpubkey_address.prefix(15)))...")
                        .foregroundColor(Color("laranja"))
                        .font(.system(size: 12))
                    } else {
                      Text("Coinbase")
                        .foregroundColor(Color("cinza"))
                        .font(.system(size: 12))
                    }
                    
                    Text("\(transactions.vout[index].value / 100000000) BTC")
                      .foregroundColor(Color("cinza"))
                      .font(.system(size: 12))
                    
                  }
                }
                
              }.padding()
                .background(Color("caixas")).cornerRadius(7)
            }.padding(.horizontal)
            
          }
        }
      }.scrollIndicators(.hidden)
    }.onAppear() {
      if idTransacaoButton == "" {
        transaction.getEachTransactionInfo(idTransacaoSearch)
        //print(idTransacaoSearch) teste
      } else {
        transaction.getEachTransactionInfo(idTransacaoButton)
      }
      
      lastBlock.getLastBlock()
      
    }
    
  }
}
