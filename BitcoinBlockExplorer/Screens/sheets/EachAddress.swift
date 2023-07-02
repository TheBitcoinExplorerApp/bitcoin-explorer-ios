//
//  EachAddress.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

struct EachAddress: View {
  
  @StateObject var address = AddressDataHeader()
  @StateObject var addressTransactions = AddressDataTransactions()
  @Binding var addressSearch: String
  @Binding var abrirModalAddress: Bool
  
  var largura = UIScreen.main.bounds.size.width
  
  var body: some View {
    
    VStack{
      ScrollView{
        
        HStack{
          Spacer()
          Text("Endereço").foregroundColor(Color("cinza")).offset(x: 15, y: 15)
          Spacer()
          Button{
            abrirModalAddress.toggle()
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
        
        if address.erro == nil {
          Button{
            UIPasteboard.general.string = "\(addressSearch)"
          } label: {
            VStack{
              HStack{
                Text("Endereço").foregroundColor(Color("cinza")).font(.system(size: 15))
                Spacer()
                Text("\(String(addressSearch.prefix(25)))...").foregroundColor(Color("laranja")).font(.system(size: 15))
              }.padding()
                .background(Color("caixas"))
                .frame(height: 40)
                .cornerRadius(7)
            }.padding(.horizontal)
            
          }
        } else {
          Text("Não encontrado").font(.system(size: 28)).foregroundColor(Color("cinza"))
        }
        
        ForEach(address.addressDatasHeader, id: \.self) { address in
          
          VStack{
            VStack{
              HStack{
                Text("Total Recebido").foregroundColor(Color("cinza")).font(.system(size: 15))
                Spacer()
                Text("\(address.chain_stats.funded_txo_sum / 100000000) BTC").foregroundColor(Color("laranja")).font(.system(size: 15))
              }
              
              Divider().padding(.horizontal, -largura)
              
              HStack{
                Text("Total Enviado").foregroundColor(Color("cinza")).font(.system(size: 15))
                Spacer()
                Text("\(address.chain_stats.spent_txo_sum / 100000000) BTC").foregroundColor(Color("laranja")).font(.system(size: 15))
              }
              
              Divider().padding(.horizontal, -largura)
              
              HStack{
                Text("Saldo ").foregroundColor(Color("cinza")).font(.system(size: 15))
                Spacer()
                Text("\((address.chain_stats.funded_txo_sum - address.chain_stats.spent_txo_sum) / 100000000) BTC").foregroundColor(Color("laranja")).font(.system(size: 15))
              }
            }.padding()
              .background(Color("caixas"))
              .cornerRadius(7)
          }.padding(.horizontal)
          
        }
        
        if address.erro == nil {
          HStack{
            Text("Transações").foregroundColor(Color("cinza")).font(.system(size: 15))
            Spacer()
          }.padding(.top)
            .padding(.horizontal)
        } else {
          
        }
        
        if addressTransactions.loading{
          ProgressView()
        } else {
          
          ForEach(addressTransactions.addressDataTransactions, id: \.self) { addressTransaction in
            
            Button{
              UIPasteboard.general.string = "\(addressTransaction.txid)"
            } label: {
              VStack{
                HStack{
                  
                  Text("\(String(addressTransaction.txid.prefix(30)))...").foregroundColor(Color("laranja")).font(.system(size: 12))
                  Spacer()
                  
                  if let addressTimeDesembrulhado = addressTransaction.status.block_time, let formattedTime = addressTransaction.status.formatTime(addressTimeDesembrulhado) {
                    Text(formattedTime)
                      .foregroundColor(Color("cinza")).opacity(0.6)
                      .font(.system(size: 12))
                  }
                }.padding()
                  .background(Color("caixas"))
                  .frame(maxHeight: 40)
                  .cornerRadius(7)
              }.padding(.horizontal)
              
            }
            
            VStack{
              HStack{
                VStack{
                  ForEach(addressTransaction.vin, id: \.self) { vin in
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
                  ForEach(addressTransaction.vout.indices, id: \.self) { index in
                    if let scriptpubkey_address_saida = addressTransaction.vout[index].scriptpubkey_address {
                      Text("\(String(scriptpubkey_address_saida.prefix(15)))...")
                        .foregroundColor(Color("cinza"))
                        .font(.system(size: 12))
                    } else {
                      Text("Coinbase")
                        .foregroundColor(Color("cinza"))
                        .font(.system(size: 12))
                    }
                    
                    Text("\(addressTransaction.vout[index].value / 100000000) BTC")
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
      
    }.onAppear(){
      address.getAddressInfoHeader(addressSearch)
      addressTransactions.getAddressInfoTransactions(addressSearch)
    }
    
    
  }
}
     
