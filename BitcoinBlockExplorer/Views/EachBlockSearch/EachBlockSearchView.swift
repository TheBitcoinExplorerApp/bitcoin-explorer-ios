//
//  EachBlockSearchView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 05/02/25.
//

import SwiftUI

struct EachBlockSearchView: View {

    @EnvironmentObject var viewModel: EachBlockSearchViewModel
    @Binding var abrirModalBlock: Bool
        
    @State private var showToast: Bool = false
    
    var largura = UIScreen.main.bounds.size.width
    
    var body: some View {
        
        VStack{
            ScrollView{
                
                header
                
                HStack{
                    Text("\(viewModel.eachBlockHeaderSearch?.tx_count ?? 0) \(Texts.transacoesMaiusculo)")
                        .foregroundColor(Color.texts)
                        .font(.callout)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
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
            viewModel.fetchEachBlock()
        }
        
        .onDisappear(perform: {
            viewModel.height = nil
            viewModel.hash = nil
        })

        .sheetToolbar(title: Texts.blocoMaiusculo)
        
        .errorAlert(showAlert: $viewModel.showErrorAlert, errorMessage: $viewModel.errorMessage)
        
    }
    
    private var header: some View {
        VStack {
            HStack{
                
                HStack{
                    Text(Texts.blocoMaiusculo)
                        .foregroundColor(Color.texts)
                        .font(.callout)
                    Text("\(viewModel.height ?? 0)")
                        .foregroundColor(Color.texts)
                        .font(.callout)
                }
                .padding()
                .background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                
                Spacer()
            }.padding()
            
            Button{
                UIPasteboard.general.string = "\(viewModel.hash ?? "")"
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
            } label: {
                
                VStack{
                    HStack{
                        Text(Texts.hash)
                            .foregroundColor(Color.texts)
                            .font(.callout)
                        Spacer()
                        Text("\(String(viewModel.hash ?? ""))...")
                            .foregroundColor(Color.primaryText)
                            .font(.callout)
                            .lineLimit(1)
                    }.padding()
                        .background(Color.backgroundBox)
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                }.padding(.horizontal)
                
            }
            
            VStack{
                HStack{
                    Text(Texts.dataEHora)
                        .foregroundColor(Color.texts)
                        .font(.callout)
                    Spacer()
                    Text("\(viewModel.eachBlockHeaderSearch?.formatTimestampWithHour(viewModel.eachBlockHeaderSearch?.timestamp ?? 0) ?? "")")
                        .foregroundColor(Color.primaryText)
                        .font(.callout)
                }
                
                Divider()
                    .padding(.horizontal, -largura)
                
                HStack{
                                        
                    Text(Texts.tamanhoMaiusculo)
                        .foregroundColor(Color.texts)
                        .font(.callout)
                    Spacer()
                    Text("\(sizeInByteOrMB())")
                        .foregroundColor(Color.primaryText)
                        .font(.callout)
                }
                
                Divider()
                    .padding(.horizontal, -largura)
                
                HStack{
                    Text(Texts.taxaMediana)
                        .foregroundColor(Color.texts)
                        .font(.callout)
                    Spacer()
                    Text("~\(Int(viewModel.eachBlockHeaderSearch?.extras.medianFee ?? 0)) \(Texts.satVb)")
                        .foregroundColor(Color.primaryText)
                        .font(.callout)
                }
                
                Divider().padding(.horizontal, -largura)
                
                HStack{
                    Text(Texts.minerador)
                        .foregroundColor(Color.texts)
                        .font(.callout)
                    Spacer()
                    Text("\(viewModel.eachBlockHeaderSearch?.extras.pool.name ?? "")")
                        .foregroundColor(Color.primaryText)
                        .font(.callout)
                }
                
            }
            .padding()
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
            .padding(.horizontal)
            
        }
    }
    
    private var transactions: some View {
        ForEach(viewModel.blockTransactionsSearch, id: \.self) { transaction in
            
            Button{
                UIPasteboard.general.string = "\(transaction.txid)"
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
            } label: {
                
                VStack{
                    HStack{
                        // Id da transacao
                        Text("\(transaction.txid)")
                            .foregroundStyle(Color.primaryText)
                            .font(.footnote)
                            .lineLimit(1)
                        
                        Image(systemName: "clipboard.fill")
                            .resizable()
                            .frame(width: 10, height: 15)
                            .foregroundStyle(Color.primaryText)
                        
                        Spacer()
                    }.padding()
                        .background(Color.backgroundBox)
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
                }.padding(.horizontal)
                
            }
            
            VStack{
                HStack{
                    VStack{
                        ForEach(transaction.vin, id: \.self) { vin in
                            if let prevoutDesembrulhado: Prevout = vin.prevout {
                                Text("\(String(prevoutDesembrulhado.scriptpubkey_address.prefix(15)))...")
                                    .foregroundColor(Color.texts)
                                    .font(.footnote)
                                    .lineLimit(1)
                                
                                let valueDesembrulhado = prevoutDesembrulhado.value / Double.BtcInSats
                                
                                Text("\(String(format: "%.8f", valueDesembrulhado)) BTC")
                                    .foregroundColor(Color.texts)
                                    .font(.footnote)
                                
                                CurrencyView(rate: valueDesembrulhado)
                                    .font(.caption)
                                    .foregroundStyle(Color.primaryText)
                                
                            } else {
                                Text(Texts.coinbase)
                                    .foregroundColor(Color.texts)
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
                        ForEach(transaction.vout.indices, id: \.self) { index in
                            if let scriptpubkey_address = transaction.vout[index].scriptpubkey_address {
                                Text("\(String(scriptpubkey_address.prefix(15)))...")
                                    .foregroundColor(Color.texts)
                                    .font(.footnote)
                                    .lineLimit(1)
                            } else {
                                Text(Texts.opReturn)
                                    .foregroundColor(Color.texts)
                                    .font(.footnote)
                            }
                            
                            let valueVout = transaction.vout[index].value / Double.BtcInSats
                            
                            Text("\(String(format: "%.8f", valueVout)) BTC")
                                .foregroundColor(Color.texts)
                                .font(.footnote)
                            
                            CurrencyView(rate: valueVout)
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
    
    func sizeInByteOrMB() -> String {
        let tamanho = ((viewModel.eachBlockHeaderSearch?.size ?? 0) / Double.bytesToMB)
        
        if tamanho < 1 {
            return "\(String(format: "%.0f", viewModel.eachBlockHeaderSearch?.size ?? 0)) B"
        } else {
            return "\(String(format: "%.2f", tamanho)) \(Texts.MB)"
        }
    }
}

#Preview {
    
    EachBlockSearchView(abrirModalBlock: .constant(true))
        .environmentObject(EachBlockSearchViewModel())
}
