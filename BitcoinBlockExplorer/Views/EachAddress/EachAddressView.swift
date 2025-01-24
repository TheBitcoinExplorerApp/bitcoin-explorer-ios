//
//  EachAddressView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

struct EachAddressView: View {
    
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
                                        .foregroundStyle(Color.texts)
                                        .font(.callout)
                                    Spacer()
                                    Text("\(String(addressSearch.prefix(25)))...")
                                        .foregroundStyle(Color.primaryText)
                                        .lineLimit(1)
                                        .font(.callout)
                                }.padding()
                                    .background(Color.backgroundBox)
                                    .cornerRadius(7)
                            }.padding(.horizontal)
                            
                        }
                    } else {
                        Text(TransactionsTexts.naoEncontrado)
                            .font(.title)
                            .foregroundStyle(Color.texts)
                    }
                    
                    ForEach(address.addressDatasHeader, id: \.self) { address in
                        
                        VStack{
                            VStack{
                                HStack{
                                    Text(AddressTexts.totalRecebido)
                                        .foregroundStyle(Color.texts)
                                        .font(.callout)
                                    Spacer()
                                    
                                    VStack {
                                        
                                        let received = address.chain_stats.funded_txo_sum / 100000000
                                        
                                    Text("\(received) BTC")
                                        .foregroundStyle(Color.primaryText)
                                        .font(.callout)
                                        
                                        CurrencyView(rate: received)
                                            .font(.footnote)
                                            .foregroundStyle(Color.texts)
                                        
                                    }
                                }
                                
                                Divider().padding(.horizontal, -largura)
                                
                                HStack{
                                    Text(AddressTexts.totalEnviado)
                                        .foregroundStyle(Color.texts)
                                        .font(.callout)
                                    Spacer()
                                    
                                    VStack{
                                        
                                        let sent = address.chain_stats.spent_txo_sum / 100000000
                                        
                                        Text("\(sent) BTC")
                                            .foregroundStyle(Color.primaryText)
                                            .font(.callout)
                                        
                                        CurrencyView(rate: sent)
                                            .font(.footnote)
                                            .foregroundStyle(Color.texts)
                                        
                                    }
                                    
                                }
                                
                                Divider().padding(.horizontal, -largura)
                                
                                HStack{
                                    Text(AddressTexts.saldo)
                                        .foregroundStyle(Color.texts)
                                        .font(.callout)
                                    Spacer()
                                    
                                    VStack{
                                        
                                        let balance = (address.chain_stats.funded_txo_sum - address.chain_stats.spent_txo_sum) / 100000000
                                        
                                        Text("\(balance) BTC")
                                            .foregroundStyle(Color.primaryText)
                                            .font(.callout)
                                        
                                        CurrencyView(rate: balance)
                                            .font(.footnote)
                                            .foregroundStyle(Color.texts)
                                    }
                                    
                                }
                            }.padding()
                                .background(Color.backgroundBox)
                                .cornerRadius(7)
                        }.padding(.horizontal)
                        
                    }
                    
                    if address.erro == nil {
                        HStack{
                            Text(TransactionsTexts.transacoesMaiusculo)
                                .foregroundStyle(Color.texts)
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
                                            .foregroundStyle(Color.primaryText)
                                            .lineLimit(1)
                                            .font(.footnote)
                                        Spacer()
                                        
                                        if let addressTimeDesembrulhado = addressTransaction.status.block_time, let formattedTime = addressTransaction.status.formatTime(addressTimeDesembrulhado) {
                                            Text(formattedTime)
                                                .foregroundStyle(Color.texts)
                                                .opacity(0.6)
                                                .font(.footnote)
                                        }
                                    }.padding()
                                        .background(Color.backgroundBox)
                                        .cornerRadius(7)
                                }.padding(.horizontal)
                                
                            }
                            
                            VStack{
                                HStack{
                                    VStack{
                                        ForEach(addressTransaction.vin, id: \.self) { vin in
                                            if let prevoutDesembrulhado: Prevout = vin.prevout {
                                                Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...")
                                                    .foregroundStyle(Color.texts)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                                
                                                let prevDesembrulhado = prevoutDesembrulhado.value / 100000000
                                                
                                                Text("\(prevDesembrulhado) BTC")
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                                
                                                CurrencyView(rate: prevDesembrulhado)
                                                    .font(.caption)
                                                    .foregroundStyle(Color.primaryText)
                                                
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    Image(TransactionsTexts.setinha)
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.texts)
                                    Spacer()
                                    
                                    VStack {
                                        ForEach(addressTransaction.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address_saida = addressTransaction.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address_saida.prefix(15)))...")
                                                    .foregroundStyle(Color.texts)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                            }
                                            
                                            let vOut = addressTransaction.vout[index].value / 100000000
                                            
                                            Text("\(vOut) BTC")
                                                .foregroundStyle(Color.texts)
                                                .font(.footnote)
                                            
                                            CurrencyView(rate: vOut)
                                                .font(.caption)
                                                .foregroundStyle(Color.primaryText)
                                            
                                        }
                                    }
                                    
                                }.padding()
                                    .background(Color.backgroundBox)
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
            
            .sheetToolbar(title: AddressTexts.enderecoMaiusculo)
            
        }
        
    }
}
