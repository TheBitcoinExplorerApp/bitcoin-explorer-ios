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
        
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    
                    if address.erro == nil {
                        Button{
                            UIPasteboard.general.string = "\(addressSearch)"
                        } label: {
                            VStack{
                                HStack{
                                    Text(AddressTexts.enderecoMaiusculo)
                                        .foregroundColor(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    Text("\(String(addressSearch.prefix(25)))...")
                                        .foregroundColor(Color.laranja)
                                        .lineLimit(1)
                                        .font(.callout)
                                }.padding()
                                    .background(Color.caixas)
                                    .cornerRadius(7)
                            }.padding(.horizontal)
                            
                        }
                    } else {
                        Text(TransactionsTexts.naoEncontrado)
                            .font(.title)
                            .foregroundColor(Color.cinza)
                    }
                    
                    ForEach(address.addressDatasHeader, id: \.self) { address in
                        
                        VStack{
                            VStack{
                                HStack{
                                    Text(AddressTexts.totalRecebido)
                                        .foregroundColor(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    Text("\(address.chain_stats.funded_txo_sum / 100000000) BTC")
                                        .foregroundColor(Color.laranja)
                                        .font(.callout)
                                }
                                
                                Divider().padding(.horizontal, -largura)
                                
                                HStack{
                                    Text(AddressTexts.totalEnviado)
                                        .foregroundColor(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    Text("\(address.chain_stats.spent_txo_sum / 100000000) BTC")
                                        .foregroundColor(Color.laranja)
                                        .font(.callout)
                                }
                                
                                Divider().padding(.horizontal, -largura)
                                
                                HStack{
                                    Text(AddressTexts.saldo)
                                        .foregroundColor(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    Text("\((address.chain_stats.funded_txo_sum - address.chain_stats.spent_txo_sum) / 100000000) BTC")
                                        .foregroundColor(Color.laranja)
                                        .font(.callout)
                                }
                            }.padding()
                                .background(Color.caixas)
                                .cornerRadius(7)
                        }.padding(.horizontal)
                        
                    }
                    
                    if address.erro == nil {
                        HStack{
                            Text(TransactionsTexts.transacoesMaiusculo)
                                .foregroundColor(Color.cinza)
                                .font(.callout)
                            Spacer()
                        }.padding(.top)
                            .padding(.horizontal)
                    } else {
                        
                    }
                    
                    if addressTransactions.loading{
                        ProgressView().scaleEffect(1.2)
                    } else {
                        
                        ForEach(addressTransactions.addressDataTransactions, id: \.self) { addressTransaction in
                            
                            Button{
                                UIPasteboard.general.string = "\(addressTransaction.txid)"
                            } label: {
                                VStack{
                                    HStack{
                                        
                                        Text("\(String(addressTransaction.txid.prefix(30)))...")
                                            .foregroundColor(Color.laranja)
                                            .lineLimit(1)
                                            .font(.footnote)
                                        Spacer()
                                        
                                        if let addressTimeDesembrulhado = addressTransaction.status.block_time, let formattedTime = addressTransaction.status.formatTime(addressTimeDesembrulhado) {
                                            Text(formattedTime)
                                                .foregroundColor(Color.cinza)
                                                .opacity(0.6)
                                                .font(.footnote)
                                        }
                                    }.padding()
                                        .background(Color.caixas)
                                        .cornerRadius(7)
                                }.padding(.horizontal)
                                
                            }
                            
                            VStack{
                                HStack{
                                    VStack{
                                        ForEach(addressTransaction.vin, id: \.self) { vin in
                                            if let prevoutDesembrulhado: Prevout = vin.prevout {
                                                Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...")
                                                    .foregroundColor(Color.cinza)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                                Text("\(prevoutDesembrulhado.value / 100000000) BTC")
                                                    .foregroundColor(Color.cinza)
                                                    .font(.footnote)
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundColor(Color.cinza)
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    Image(TransactionsTexts.setinha)
                                        .foregroundColor(Color.cinza)
                                    Spacer()
                                    
                                    VStack {
                                        ForEach(addressTransaction.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address_saida = addressTransaction.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address_saida.prefix(15)))...")
                                                    .foregroundColor(Color.cinza)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundColor(Color.cinza)
                                                    .font(.footnote)
                                            }
                                            
                                            Text("\(addressTransaction.vout[index].value / 100000000) BTC")
                                                .foregroundColor(Color.cinza)
                                                .font(.footnote)
                                            
                                        }
                                    }
                                    
                                }.padding()
                                    .background(Color.caixas)
                                    .cornerRadius(7)
                            }.padding(.horizontal)
                            
                            HStack {
                            }.padding(.bottom, 20)
                            
                        }
                    }
                }
                
            }
            .task {
                address.getAddressInfoHeader(addressSearch)
                addressTransactions.getAddressInfoTransactions(addressSearch)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        abrirModalAddress.toggle()
                    } label: {
                        Circle()
                            .fill()
                            .foregroundColor(Color.cinza)
                            .frame(width: 30, height: 30)
                            .overlay() {
                                Text("X")
                                    .clipShape(Circle())
                                    .font(.system(size: 22.5))
                                    .foregroundColor(Color.laranja)
                            }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(AddressTexts.enderecoMaiusculo)
                        .foregroundColor(Color.cinza)
                        .bold()
                        .font(.headline)
                }
            }.toolbarBackground(Color.azul, for: .navigationBar)
            
            
        }
        
    }
}

