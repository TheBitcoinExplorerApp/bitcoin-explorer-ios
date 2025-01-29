//
//  BoxTransactions.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

struct BoxTransactions: View {
    @StateObject var transactionData = TransactionData()
    @State var idTransacaoButton: String = ""
    @State var idTransacaoSearch: String = ""
    @State var abrirModalTransaction: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text(Texts.transacoesMaiusculo).foregroundColor(Color.texts)
                    .bold()
                    .font(.headline)
                Spacer()
            }
            
            if transactionData.carregando{
                ProgressView().scaleEffect(1.2)
            } else {
                
                LazyVStack(spacing: 10){
                    ForEach(transactionData.transactionDatas, id: \.self) { transactions in
                        
                        Button{
                            abrirModalTransaction.toggle()
                        } label: {
                            
                            HStack{
                                VStack{
                                    Spacer()
                                    Text(Texts.idTransacao)
                                        .font(.footnote)
                                        .foregroundColor(Color.texts)
                                    Spacer()
                                    Spacer()
                                    Text("\(transactions.txid)").foregroundColor(Color.primaryText)
                                        .font(.footnote)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                
                                VStack{
                                    Spacer()
                                    Text(Texts.valorMaiusculo)
                                        .font(.footnote)
                                        .foregroundColor(Color.texts)
                                    Spacer()
                                    Spacer()
                                    let value = transactions.value / 100000000
                                    
                                    Text("\(value) BTC")
                                        .font(.footnote)
                                        .foregroundColor(Color.texts)
                                    
                                    Spacer()
                                }
                                
                                VStack{
                                    Spacer()
                                    Text(Texts.taxaMaiusculo)
                                        .font(.footnote)
                                        .foregroundColor(Color.texts)
                                    Spacer()
                                    Spacer()
                                    Text("\(Int(transactions.fee)) \(Texts.sat)")
                                        .font(.footnote)
                                        .foregroundColor(Color.texts)
                                    Spacer()
                                }
                                
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                                .frame(maxWidth: .infinity)
                                .background(Color.backgroundBox).cornerRadius(7)
                                .onTapGesture {
                                    idTransacaoButton = transactions.txid
                                    abrirModalTransaction.toggle()
                                }
                            
                        }
                        
                    }
                }
                
            }
            
        }
        .padding()
        .sheet(isPresented: $abrirModalTransaction) {
            EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction)
                .presentationBackground(Color.background)
        }
        
        .task {
            transactionData.getTransactionData()
        }
        
    }
    
}

struct BoxTransactions_Previews: PreviewProvider {
    static var previews: some View {
        BoxTransactions()
    }
}
