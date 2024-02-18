//
//  EachBlock.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 17/05/23.
//

import SwiftUI

struct EachBlock: View {
    @StateObject var blockTransactionData = BlockTransactionsData()
    
    @Binding var timestamp: String
    @Binding var numberTransactions: Int64
    @Binding var blockMiner: String
    @Binding var medianFee: Double
    @Binding var blockSize: Double
    @Binding var hashBlock: String
    @Binding var heightBlock: Int
    @Binding var abrirModal: Bool
    
    var largura = UIScreen.main.bounds.size.width
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                ScrollView{
                    
                    HStack{
                        
                        HStack{
                            Text(BlocksTexts.blocoMaiusculo)
                                .foregroundColor(Color.cinza)
                                .font(.callout)
                            Text("\(heightBlock)")
                                .foregroundColor(Color.cinza)
                                .font(.callout)
                        }
                        .padding()
                        .background(Color.caixas)
                        .cornerRadius(7)
                        
                        Spacer()
                    }.padding()
                    
                    Button{
                        UIPasteboard.general.string = "\(hashBlock)"
                    } label: {
                        
                        VStack{
                            HStack{
                                Text(BlocksTexts.hash)
                                    .foregroundColor(Color.cinza)
                                    .font(.callout)
                                Spacer()
                                Text("\(String(hashBlock.prefix(25)))...")
                                    .foregroundColor(Color.laranja)
                                    .font(.callout)
                                    .lineLimit(1)
                            }.padding()
                                .background(Color.caixas)
                                .cornerRadius(7)
                        }.padding(.horizontal)
                        
                    }
                    
                    VStack{
                        VStack{
                            HStack{
                                Text(BlocksTexts.dataEHora)
                                    .foregroundColor(Color.cinza)
                                    .font(.callout)
                                Spacer()
                                Text("\(timestamp)")
                                    .foregroundColor(Color.laranja)
                                    .font(.callout)
                            }
                            
                            Divider().padding(.horizontal, -largura)
                            
                            HStack{
                                let tamanho = String(format: "%.2f", (blockSize / 1000000))
                                
                                Text(BlocksTexts.tamanhoMaiusculo)
                                    .foregroundColor(Color.cinza)
                                    .font(.callout)
                                Spacer()
                                Text("\(tamanho) \(BlocksTexts.MB)")
                                    .foregroundColor(Color.laranja)
                                    .font(.callout)
                            }
                            
                            Divider().padding(.horizontal, -largura)
                            
                            HStack{
                                Text(BlocksTexts.taxaMediana)
                                    .foregroundColor(Color.cinza)
                                    .font(.callout)
                                Spacer()
                                Text("~\(Int(medianFee)) \(Texts.satVb)")
                                    .foregroundColor(Color.laranja)
                                    .font(.callout)
                            }
                            
                            Divider().padding(.horizontal, -largura)
                            
                            HStack{
                                Text(BlocksTexts.minerador)
                                    .foregroundColor(Color.cinza)
                                    .font(.callout)
                                Spacer()
                                Text("\(blockMiner)")
                                    .foregroundColor(Color.laranja)
                                    .font(.callout)
                            }
                            
                        }.padding()
                            .background(Color.caixas)
                            .cornerRadius(7)
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("\(numberTransactions) \(TransactionsTexts.transacoesMaiusculo)")
                            .foregroundColor(Color.cinza)
                            .font(.callout)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if blockTransactionData.loading{
                        ProgressView().scaleEffect(1.2)
                    } else {
                        
                        ForEach(blockTransactionData.blockTransactionsData, id: \.self) { blocksT in
                            
                            Button{
                                UIPasteboard.general.string = "\(blocksT.txid)"
                            } label: {
                                
                                VStack{
                                    HStack{
                                        // Id da transacao
                                        Text("\(blocksT.txid)")
                                            .foregroundColor(Color.laranja)
                                            .font(.footnote)
                                            .lineLimit(1)
                                        Spacer()
                                        // data transacao
                                        if let blockTimeDesembrulhado = blocksT.status.block_time, let formattedTime = blocksT.status.formatTime(blockTimeDesembrulhado) {
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
                                        ForEach(blocksT.vin, id: \.self) { vin in
                                            if let prevoutDesembrulhado: Prevout = vin.prevout {
                                                Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...")
                                                    .foregroundColor(Color.cinza)
                                                    .font(.footnote)
                                                    .lineLimit(1)
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
                                        ForEach(blocksT.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address = blocksT.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address.prefix(15)))...")
                                                    .foregroundColor(Color.cinza)
                                                    .font(.footnote)
                                                    .lineLimit(1)
                                            } else {
                                                Text(TransactionsTexts.opReturn)
                                                    .foregroundColor(Color.cinza)
                                                    .font(.footnote)
                                            }
                                            
                                            Text("\(blocksT.vout[index].value / 100000000) BTC")
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
                blockTransactionData.getEachBlocksInfo(hashBlock)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        abrirModal.toggle()
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
                    Text(BlocksTexts.blocoMaiusculo)
                        .foregroundColor(Color.cinza)
                        .bold()
                        .font(.headline)
                }
            }.toolbarBackground(Color.azul, for: .navigationBar)
            
        }
        
    }
}
