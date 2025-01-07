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
                                .foregroundColor(Color.texts)
                                .font(.callout)
                            Text("\(heightBlock)")
                                .foregroundColor(Color.texts)
                                .font(.callout)
                        }
                        .padding()
                        .background(Color.backgroundBox)
                        .cornerRadius(7)
                        
                        Spacer()
                    }.padding()
                    
                    Button{
                        UIPasteboard.general.string = "\(hashBlock)"
                    } label: {
                        
                        VStack{
                            HStack{
                                Text(BlocksTexts.hash)
                                    .foregroundColor(Color.texts)
                                    .font(.callout)
                                Spacer()
                                Text("\(String(hashBlock.prefix(25)))...")
                                    .foregroundColor(Color.primaryText)
                                    .font(.callout)
                                    .lineLimit(1)
                            }.padding()
                                .background(Color.backgroundBox)
                                .cornerRadius(7)
                        }.padding(.horizontal)
                        
                    }
                    
                    VStack{
                        VStack{
                            HStack{
                                Text(BlocksTexts.dataEHora)
                                    .foregroundColor(Color.texts)
                                    .font(.callout)
                                Spacer()
                                Text("\(timestamp)")
                                    .foregroundColor(Color.primaryText)
                                    .font(.callout)
                            }
                            
                            Divider().padding(.horizontal, -largura)
                            
                            HStack{
                                let tamanho = String(format: "%.2f", (blockSize / 1000000))
                                
                                Text(BlocksTexts.tamanhoMaiusculo)
                                    .foregroundColor(Color.texts)
                                    .font(.callout)
                                Spacer()
                                Text("\(tamanho) \(BlocksTexts.MB)")
                                    .foregroundColor(Color.primaryText)
                                    .font(.callout)
                            }
                            
                            Divider().padding(.horizontal, -largura)
                            
                            HStack{
                                Text(BlocksTexts.taxaMediana)
                                    .foregroundColor(Color.texts)
                                    .font(.callout)
                                Spacer()
                                Text("~\(Int(medianFee)) \(Texts.satVb)")
                                    .foregroundColor(Color.primaryText)
                                    .font(.callout)
                            }
                            
                            Divider().padding(.horizontal, -largura)
                            
                            HStack{
                                Text(BlocksTexts.minerador)
                                    .foregroundColor(Color.texts)
                                    .font(.callout)
                                Spacer()
                                Text("\(blockMiner)")
                                    .foregroundColor(Color.primaryText)
                                    .font(.callout)
                            }
                            
                        }.padding()
                            .background(Color.backgroundBox)
                            .cornerRadius(7)
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("\(numberTransactions) \(TransactionsTexts.transacoesMaiusculo)")
                            .foregroundColor(Color.texts)
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
                                            .foregroundStyle(Color.primaryText)
                                            .font(.footnote)
                                            .lineLimit(1)
                     
                                        Image(systemName: "clipboard.fill")
                                            .resizable()
                                            .frame(width: 10, height: 15)
                                            .foregroundStyle(Color.primaryText)
                            
                                        Spacer()
                                        // data transacao
                                        if let blockTimeDesembrulhado = blocksT.status.block_time, let formattedTime = blocksT.status.formatTime(blockTimeDesembrulhado) {
                                            Text(formattedTime)
                                                .foregroundColor(Color.texts)
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
                                        ForEach(blocksT.vin, id: \.self) { vin in
                                            if let prevoutDesembrulhado: Prevout = vin.prevout {
                                                Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...")
                                                    .foregroundColor(Color.texts)
                                                    .font(.footnote)
                                                    .lineLimit(1)
                                                
                                                let valueDesembrulhado = prevoutDesembrulhado.value / 100000000
                                                
                                                Text("\(valueDesembrulhado) BTC")
                                                    .foregroundColor(Color.texts)
                                                    .font(.footnote)
                                                
                                                CurrencyViewComponent(rate: valueDesembrulhado)
                                                    .font(.caption)
                                                    .foregroundStyle(Color.primaryText)
                                                
                                            } else {
                                                Text(TransactionsTexts.coinbase)
                                                    .foregroundColor(Color.texts)
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
                                        ForEach(blocksT.vout.indices, id: \.self) { index in
                                            if let scriptpubkey_address = blocksT.vout[index].scriptpubkey_address {
                                                Text("\(String(scriptpubkey_address.prefix(15)))...")
                                                    .foregroundColor(Color.texts)
                                                    .font(.footnote)
                                                    .lineLimit(1)
                                            } else {
                                                Text(TransactionsTexts.opReturn)
                                                    .foregroundColor(Color.texts)
                                                    .font(.footnote)
                                            }
                                            
                                            let valueVout = blocksT.vout[index].value / 100000000
                                            
                                            Text("\(valueVout) BTC")
                                                .foregroundColor(Color.texts)
                                                .font(.footnote)
                                            
                                            CurrencyViewComponent(rate: valueVout)
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
                blockTransactionData.getEachBlocksInfo(hashBlock)
            }
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        abrirModal.toggle()
                    } label: {
                        Circle()
                            .fill()
                            .foregroundStyle(Color.dismissBackground)
                            .frame(width: 30, height: 30)
                            .overlay() {
                                Text("X")
                                    .clipShape(Circle())
                                    .font(.system(size: 22.5))
                                    .foregroundColor(Color.primaryText)
                            }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(BlocksTexts.blocoMaiusculo)
                        .foregroundStyle(Color.texts)
                        .bold()
                        .font(.headline)
                }
            }
            .toolbarBackground(Color.background, for: .navigationBar)
            
        }
        
    }
}

#Preview {
    EachBlock(timestamp: .constant("teere"), numberTransactions: .constant(1234), blockMiner: .constant("sssdsd"), medianFee: .constant(2.32332), blockSize: .constant(2.32332), hashBlock: .constant("ssmdismd"), heightBlock: .constant(1223), abrirModal: .constant(false))
}
