//
//  EachAddressView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

struct EachAddressView: View {
    
    @StateObject var viewModel = EachAddressViewModel()
    
    @Binding var addressSearch: String
    @Binding var abrirModalAddress: Bool
    
    @State private var showToast: Bool = false
    
    var largura = UIScreen.main.bounds.size.width
    
    var body: some View {
                    
            VStack {
                
                ScrollView {
                    headerView
                    
                    if viewModel.loading {
                        ProgressView().scaleEffect(1.2)
                    } else {
                        transactions
                    }
                }
            }
        
            .overlay {
                if showToast {
                    withAnimation() {
                        ToastView()
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .transition(.move(edge: .bottom))
                    }
                    
                }
            }
        
            .task {
                viewModel.getEachAddress(addressSearch)
            }
            
            .sheetToolbar(title: Texts.enderecoMaiusculo)
        
            .errorAlert(showAlert: $viewModel.showErrorAlert, errorMessage: $viewModel.errorType)
     
    }
    
    private var headerView: some View {
        VStack {
            Button{
                UIPasteboard.general.string = "\(addressSearch)"
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
            } label: {
                VStack{
                    HStack{
                        Text(Texts.enderecoMaiusculo)
                            .foregroundStyle(Color.texts)
                            .font(.callout)
                        Spacer()
                        Text("\(String(addressSearch.prefix(25)))...")
                            .foregroundStyle(Color.primaryText)
                            .lineLimit(1)
                            .font(.callout)
                    }.padding()
                        .background(Color.backgroundBox)
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                }.padding(.horizontal)
                
            }
            
            ForEach(viewModel.addressHeaderData, id: \.self) { address in
                
                VStack {
                    VStack {
                        HStack {
                            Text(Texts.totalRecebido)
                                .foregroundStyle(Color.texts)
                                .font(.callout)
                            
                            Spacer()
                            
                            VStack {
                                let received = address.chain_stats.funded_txo_sum / Double.BtcInSats
                               
                            Text("\(String(format: "%.8f", received)) BTC")
                                .foregroundStyle(Color.primaryText)
                                .font(.callout)
                                
                                CurrencyView(rate: received)
                                    .font(.footnote)
                                    .foregroundStyle(Color.texts)
                            }
                        }
                        
                        Divider().padding(.horizontal, -largura)
                        
                        HStack {
                            Text(Texts.totalEnviado)
                                .foregroundStyle(Color.texts)
                                .font(.callout)
                            
                            Spacer()
                            
                            VStack{
                                let sent = address.chain_stats.spent_txo_sum / Double.BtcInSats
                                
                                Text("\(String(format: "%.8f", sent)) BTC")
                                    .foregroundStyle(Color.primaryText)
                                    .font(.callout)
                                
                                CurrencyView(rate: sent)
                                    .font(.footnote)
                                    .foregroundStyle(Color.texts)
                            }
                        }
                        
                        Divider().padding(.horizontal, -largura)
                        
                        HStack {
                            Text(Texts.saldo)
                                .foregroundStyle(Color.texts)
                                .font(.callout)
                            
                            Spacer()
                            
                            VStack {
                                let balance = (address.chain_stats.funded_txo_sum - address.chain_stats.spent_txo_sum) / Double.BtcInSats
                                
                                Text("\(String(format: "%.8f", balance)) BTC")
                                    .foregroundStyle(Color.primaryText)
                                    .font(.callout)
                                
                                CurrencyView(rate: balance)
                                    .font(.footnote)
                                    .foregroundStyle(Color.texts)
                            }
                        }
                        
                    }.padding()
                        .background(Color.backgroundBox)
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                }.padding(.horizontal)
                
            }
        }
    }
    
    private var transactions: some View {
        VStack {
            HStack{
                Text(Texts.transacoesMaiusculo)
                    .foregroundStyle(Color.texts)
                    .font(.callout)
                Spacer()
            }.padding(.top)
            .padding(.horizontal)
                   
            ForEach(viewModel.addressTransactionsData, id: \.self) { addressTransaction in
                
                Button {
                    UIPasteboard.general.string = "\(addressTransaction.txid)"
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showToast = false
                    }
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
                            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
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
                                    
                                    let prevDesembrulhado = prevoutDesembrulhado.value / Double.BtcInSats
                                    
                                    Text("\(String(format: "%.8f", prevDesembrulhado)) BTC")
                                        .foregroundStyle(Color.texts)
                                        .font(.footnote)
                                    
                                    CurrencyView(rate: prevDesembrulhado)
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
                            ForEach(addressTransaction.vout.indices, id: \.self) { index in
                                if let scriptpubkey_address_saida = addressTransaction.vout[index].scriptpubkey_address {
                                    Text("\(String(scriptpubkey_address_saida.prefix(15)))...")
                                        .foregroundStyle(Color.texts)
                                        .lineLimit(1)
                                        .font(.footnote)
                                } else {
                                    Text(Texts.coinbase)
                                        .foregroundStyle(Color.texts)
                                        .font(.footnote)
                                }
                                
                                let vOut = addressTransaction.vout[index].value / Double.BtcInSats
                                
                                Text("\(String(format: "%.8f", vOut)) BTC")
                                    .foregroundStyle(Color.texts)
                                    .font(.footnote)
                                
                                CurrencyView(rate: vOut)
                                    .font(.caption)
                                    .foregroundStyle(Color.primaryText)
                            }
                        }
                        
                    }.padding()
                        .background(Color.backgroundBox)
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                }.padding(.horizontal)
                
                HStack {
                }.padding(.bottom, 20)
                
            }
        }
    }
    
}
