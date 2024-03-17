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
                                        .foregroundStyle(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    Text("\(String(addressSearch.prefix(25)))...")
                                        .foregroundStyle(Color.laranja)
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
                            .foregroundStyle(Color.cinza)
                    }
                    
                    ForEach(address.addressDatasHeader, id: \.self) { address in
                        
                        VStack{
                            VStack{
                                HStack{
                                    Text(AddressTexts.totalRecebido)
                                        .foregroundStyle(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    
                                    VStack {
                                        
                                        let received = address.chain_stats.funded_txo_sum / 100000000
                                        
                                    Text("\(received) BTC")
                                        .foregroundStyle(Color.laranja)
                                        .font(.callout)
                                        
                                        CurrencyViewComponent(rate: received)
                                            .font(.footnote)
                                            .foregroundStyle(Color.cinza)
                                        
                                    }
                                }
                                
                                Divider().padding(.horizontal, -largura)
                                
                                HStack{
                                    Text(AddressTexts.totalEnviado)
                                        .foregroundStyle(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    
                                    VStack{
                                        
                                        let sent = address.chain_stats.spent_txo_sum / 100000000
                                        
                                        Text("\(sent) BTC")
                                            .foregroundStyle(Color.laranja)
                                            .font(.callout)
                                        
                                        CurrencyViewComponent(rate: sent)
                                            .font(.footnote)
                                            .foregroundStyle(Color.cinza)
                                        
                                    }
                                    
                                }
                                
                                Divider().padding(.horizontal, -largura)
                                
                                HStack{
                                    Text(AddressTexts.saldo)
                                        .foregroundStyle(Color.cinza)
                                        .font(.callout)
                                    Spacer()
                                    
                                    VStack{
                                        
                                        let balance = (address.chain_stats.funded_txo_sum - address.chain_stats.spent_txo_sum) / 100000000
                                        
                                        Text("\(balance) BTC")
                                            .foregroundStyle(Color.laranja)
                                            .font(.callout)
                                        
                                        CurrencyViewComponent(rate: balance)
                                            .font(.footnote)
                                            .foregroundStyle(Color.cinza)
                                    }
                                    
                                }
                            }.padding()
                                .background(Color.caixas)
                                .cornerRadius(7)
                        }.padding(.horizontal)
                        
                    }
                    
                    if address.erro == nil {
                        HStack{
                            Text(TransactionsTexts.transacoesMaiusculo)
                                .foregroundStyle(Color.cinza)
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
                                            .foregroundStyle(Color.laranja)
                                            .lineLimit(1)
                                            .font(.footnote)
                                        Spacer()
                                        
                                        if let addressTimeDesembrulhado = addressTransaction.status.block_time, let formattedTime = addressTransaction.status.formatTime(addressTimeDesembrulhado) {
                                            Text(formattedTime)
                                                .foregroundStyle(Color.cinza)
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
                                                    .foregroundStyle(Color.cinza)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                                
                                                let prevDesembrulhado = prevoutDesembrulhado.value / 100000000
                                                
                                                Text("\(prevDesembrulhado) BTC")
                                                    .foregroundStyle(Color.cinza)
                                                    .font(.footnote)
                                                
                                                CurrencyViewComponent(rate: prevDesembrulhado)
                                                    .font(.caption)
                                                    .foregroundStyle(Color.laranja)
                                                
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundStyle(Color.cinza)
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    Image(TransactionsTexts.setinha)
                                        .foregroundStyle(Color.cinza)
                                    Spacer()
                                    
                                    VStack {
                                        ForEach(addressTransaction.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address_saida = addressTransaction.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address_saida.prefix(15)))...")
                                                    .foregroundStyle(Color.cinza)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundStyle(Color.cinza)
                                                    .font(.footnote)
                                            }
                                            
                                            let vOut = addressTransaction.vout[index].value / 100000000
                                            
                                            Text("\(vOut) BTC")
                                                .foregroundStyle(Color.cinza)
                                                .font(.footnote)
                                            
                                            CurrencyViewComponent(rate: vOut)
                                                .font(.caption)
                                                .foregroundStyle(Color.laranja)
                                            
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
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        abrirModalAddress.toggle()
                    } label: {
                        Circle()
                            .fill()
                            .foregroundStyle(Color.cinza)
                            .frame(width: 30, height: 30)
                            .overlay() {
                                Text("X")
                                    .clipShape(Circle())
                                    .font(.system(size: 22.5))
                                    .foregroundStyle(Color.laranja)
                            }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(AddressTexts.enderecoMaiusculo)
                        .foregroundStyle(Color.cinza)
                        .bold()
                        .font(.headline)
                }
            }.toolbarBackground(Color.azul, for: .navigationBar)
            
        }
        
    }
}
