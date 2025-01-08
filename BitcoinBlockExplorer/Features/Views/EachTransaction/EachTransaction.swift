//
//  EachTransaction.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct EachTransaction: View {
    @StateObject var transaction = EachTransactionData()
    @StateObject var lastBlock = LastBlockData()
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
                                    Text(TransactionsTexts.transacaoMaiusculo)
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
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                            }.padding(.horizontal)
                            
                        }
                        
                    } else {
                        Text(TransactionsTexts.naoEncontrado)
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
                                            Text(BlocksTexts.blocoMaiusculo)
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                            Text("\(blockHeightDesembrulhado)")
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                        }.padding()
                                            .background(Color.backgroundBox)
                                            .clipShape(RoundedRectangle(cornerRadius: 7))
                                    }.padding(.horizontal)
                                    
                                } else {
                                    
                                }
                                
                                Spacer()
                                
                                VStack{
                                    HStack{
                                        if(transactions.status.confirmed) {
                                            let confirmacoes = lastBlock.lastBlock - transactions.status.block_height! + 1
                                            let mensagem = confirmacoes > 1 ? TransactionsTexts.confirmacoes : TransactionsTexts.confirmacao
                                            Text("\(String(confirmacoes)) \(mensagem)")
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                        } else {
                                            Text(TransactionsTexts.naoConfirmada)
                                                .foregroundStyle(Color.texts)
                                                .font(.callout)
                                        }
                                    }.padding()
                                        .background(Color.backgroundBox)
                                        .clipShape(RoundedRectangle(cornerRadius: 7))
                                }.padding(.horizontal)
                                
                            }
                            
                            VStack{
                                VStack{
                                    HStack{
                                        Text(BlocksTexts.dataEHora)
                                            .foregroundStyle(Color.texts)
                                            .font(.callout)
                                        Spacer()
                                        if let blockTimeDesembrulhado = transactions.status.block_time, let formattedTime = transactions.status.formatTime(blockTimeDesembrulhado) {
                                            Text("\(formattedTime)")
                                                .foregroundStyle(Color.primaryText)
                                                .font(.callout)
                                        } else {
                                            Text(TransactionsTexts.aguardandoConfirmacao)
                                                .foregroundStyle(Color.primaryText)
                                                .font(.callout)
                                        }
                                    }
                                    
                                    Divider().padding(.horizontal, -largura)
                                    
                                    HStack{
                                        Text(BlocksTexts.tamanhoMaiusculo)
                                            .foregroundStyle(Color.texts)
                                            .font(.callout)
                                        Spacer()
                                        Text("\(transactions.size) B")
                                            .foregroundStyle(Color.primaryText)
                                            .font(.callout)
                                    }
                                    
                                    Divider().padding(.horizontal, -largura)
                                    
                                    HStack{
                                        Text(TransactionsTexts.taxaMaiusculo)
                                            .foregroundStyle(Color.texts)
                                            .font(.callout)
                                        Spacer()
                                        
                                        let fee = transactions.fee / 100000000
                                        
                                        VStack{
                                            Text("\(fee) BTC")
                                                .foregroundStyle(Color.primaryText)
                                                .font(.callout)
                                            
                                            CurrencyViewComponent(rate: fee)
                                                .font(.footnote)
                                                .foregroundStyle(Color.texts)
                                        }
                                    }
                                    
                                }.padding()
                                    .background(Color.backgroundBox)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                            }.padding(.horizontal)
                            
                            HStack{
                                Text(TransactionsTexts.entradasESaidas)
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
                                                
                                                let pValue = prevoutDesembrulhado.value / 100000000
                                                
                                                Text("\(pValue) BTC")
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                                
                                                CurrencyViewComponent(rate: pValue)
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
                                        ForEach(transactions.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address = transactions.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address.prefix(15)))...")
                                                    .foregroundStyle(Color.primaryText)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundStyle(Color.texts)
                                                    .font(.footnote)
                                            }
                                            
                                            let value = transactions.vout[index].value / 100000000
                                            
                                            Text("\(value) BTC")
                                                .foregroundStyle(Color.texts)
                                                .font(.footnote)
                                            
                                            CurrencyViewComponent(rate: value)
                                                .font(.caption)
                                                .foregroundStyle(Color.primaryText)
                                            
                                        }
                                    }
                                    
                                }.padding()
                                    .background(Color.backgroundBox)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
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
                
                lastBlock.getLastBlock()
            }
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        abrirModalTransaction.toggle()
                    } label: {
                        Circle()
                            .fill()
                            .foregroundStyle(Color.dismissBackground)
                            .frame(width: 30, height: 30)
                            .overlay() {
                                Text("X")
                                    .clipShape(Circle())
                                    .font(.system(size: 22.5))
                                    .foregroundStyle(Color.primaryText)
                            }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(TransactionsTexts.transacaoMaiusculo)
                        .foregroundStyle(Color.texts)
                        .bold()
                        .font(.headline)
                }
            }.toolbarBackground(Color.background, for: .navigationBar)
            
        }
        
    }
}
