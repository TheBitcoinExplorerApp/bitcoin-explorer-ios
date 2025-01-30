//
//  EachTransaction.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct EachTransaction: View {
    @StateObject var transaction = EachTransactionData()
    @EnvironmentObject var lastBlock: LastBlockViewModel
    @Binding var idTransacaoButton: String
    @Binding var idTransacaoSearch: String
    @Binding var abrirModalTransaction: Bool
    
    var largura = UIScreen.main.bounds.size.width
    
    var body: some View {
        
        NavigationStack{
            
            VStack {
                
                ScrollView {
                    
                    if transaction.erro == nil {
                        Button {
                            UIPasteboard.general.string = "\(idTransacaoButton) \(idTransacaoSearch)"
                        } label: {
                            
                            VStack{
                                HStack{
                                    Text(Texts.transacaoMaiusculo)
                                        .foregroundStyle(Color.texts)
                                        .font(.callout)
                                    Spacer()
                                    if(idTransacaoButton == "") {
                                        Text("\(String(idTransacaoSearch.prefix(25)))...")
                                            .foregroundStyle(Color.primaryText)
                                            .font(.callout)
                                            .lineLimit(1)
                                    } else {
                                        Text("\(String(idTransacaoButton.prefix(25)))...")
                                            .foregroundStyle(Color.primaryText)
                                            .font(.callout)
                                            .lineLimit(1)
                                    }
                                }.padding()
                                    .background(Color.backgroundBox)
                                    .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                            }.padding(.horizontal)
                            
                        }
                        
                    } else {
                        Text(Texts.naoEncontrado)
                            .font(.title)
                            .foregroundStyle(Color.texts)
                    }
                    
                    if transaction.loading{
                        ProgressView().scaleEffect(1.2)
                    } else {
                        
                        ForEach(transaction.eachTransactionDatas, id: \.self) { transactions in
                            
                            HStack{
                                
                                if let blockHeightDesembrulhado = transactions.status.block_height {
                                    VStack{
                                        HStack{
                                            Text(Texts.blocoMaiusculo)
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                            Text("\(blockHeightDesembrulhado)")
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                        }.padding()
                                            .background(Color.backgroundBox)
                                            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                                    }.padding(.horizontal)
                                    
                                } else {
                                    
                                }
                                
                                Spacer()
                                
                                VStack{
                                    HStack{
                                        if(transactions.status.confirmed) {
                                            let confirmacoes = lastBlock.lastBlock - transactions.status.block_height! + 1
                                            let mensagem = confirmacoes > 1 ? Texts.confirmacoes : Texts.confirmacao
                                            Text("\(String(confirmacoes)) \(mensagem)")
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                        } else {
                                            Text(Texts.naoConfirmada)
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                        }
                                    }.padding()
                                        .background(Color.backgroundBox)
                                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                                }.padding(.horizontal)
                                
                            }
                            
                            VStack{
                                VStack{
                                    HStack{
                                        Text(Texts.dataEHora)
                                            .foregroundStyle(Color.texts)
                                            .font(.callout)
                                        Spacer()
                                        if let blockTimeDesembrulhado = transactions.status.block_time, let formattedTime = transactions.status.formatTime(blockTimeDesembrulhado) {
                                            Text("\(formattedTime)")
                                                .foregroundStyle(Color.primaryText)
                                                .font(.callout)
                                        } else {
                                            Text(Texts.aguardandoConfirmacao)
                                                .foregroundStyle(Color.primaryText)
                                                .font(.callout)
                                        }
                                    }
                                    
                                    Divider().padding(.horizontal, -largura)
                                    
                                    HStack{
                                        Text(Texts.tamanhoMaiusculo)
                                            .foregroundStyle(Color.texts)
                                            .font(.callout)
                                        Spacer()
                                        Text("\(transactions.size) B")
                                            .foregroundStyle(Color.primaryText)
                                            .font(.callout)
                                    }
                                    
                                    Divider().padding(.horizontal, -largura)
                                    
                                    HStack{
                                        Text(Texts.taxaMaiusculo)
                                            .foregroundStyle(Color.texts)
                                            .font(.callout)
                                        Spacer()
                                        
                                        let fee = transactions.fee / Double.BtcInSats
                                        
                                        VStack{
                                            Text("\(fee) BTC")
                                                .foregroundStyle(Color.primaryText)
                                                .font(.callout)
                                            
                                            CurrencyView(rate: fee)
                                                .font(.footnote)
                                                .foregroundStyle(Color.texts)
                                        }
                                    }
                                    
                                }.padding()
                                    .background(Color.backgroundBox)
                                    .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                            }.padding(.horizontal)
                            
                            HStack{
                                Text(Texts.entradasESaidas)
                                    .foregroundStyle(Color.texts)
                                    .font(.callout)
                                Spacer()
                            }.padding(.top)
                                .padding(.horizontal)
                            
                            VStack{
                                HStack{
                                    
                                    VStack{
                                        ForEach(transactions.vin, id: \.self) { vin in
                                            if let prevoutDesembrulhado: Prevout = vin.prevout {
                                                Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...")
                                                    .foregroundStyle(Color.primaryText)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                                
                                                let pValue = prevoutDesembrulhado.value / Double.BtcInSats
                                                
                                                Text("\(pValue) BTC")
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                                
                                                CurrencyView(rate: pValue)
                                                    .font(.caption)
                                                    .foregroundStyle(Color.primaryText)
                                                
                                            } else {
                                                Text(Texts.coinbase)
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    Image(Texts.setinha)
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.texts)
                                    Spacer()
                                    
                                    VStack {
                                        ForEach(transactions.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address = transactions.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address.prefix(15)))...")
                                                    .foregroundStyle(Color.primaryText)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                            } else {
                                                Text(Texts.coinbase)
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                            }
                                            
                                            let value = transactions.vout[index].value / Double.BtcInSats
                                            
                                            Text("\(value) BTC")
                                                .foregroundStyle(Color.texts)
                                                .font(.footnote)
                                            
                                            CurrencyView(rate: value)
                                                .font(.caption)
                                                .foregroundStyle(Color.primaryText)
                                            
                                        }
                                    }
                                    
                                }.padding()
                                    .background(Color.backgroundBox)
                                    .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                            }.padding(.horizontal)
                            
                        }
                    }
                }
                
            }
            
            .task {
                if idTransacaoButton == "" {
                    transaction.getEachTransactionInfo(idTransacaoSearch)
                } else {
                    transaction.getEachTransactionInfo(idTransacaoButton)
                }
            }
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }

            .sheetToolbar(title: Texts.transacaoMaiusculo)
            
        }
        
    }
}
