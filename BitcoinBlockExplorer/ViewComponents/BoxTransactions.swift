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
        ScrollView(.vertical){
            
            HStack {
                Text(TransactionsTexts.transacoesMaiusculo).foregroundColor(Color.cinza)
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
                                    Text(TransactionsTexts.idTransacao)
                                        .font(.footnote)
                                        .foregroundColor(Color.cinza)
                                    Spacer()
                                    Spacer()
                                    Text("\(transactions.txid)").foregroundColor(Color.laranja)
                                        .font(.footnote)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                
                                VStack{
                                    Spacer()
                                    Text(TransactionsTexts.valorMaiusculo)
                                        .font(.footnote)
                                        .foregroundColor(Color.cinza)
                                    Spacer()
                                    Spacer()
                                    let value = transactions.value / 100000000
                                    
                                    Text("\(value) BTC")
                                        .font(.footnote)
                                        .foregroundColor(Color.cinza)
                                    
//                                    CurrencyView(rate: value)
//                                        .font(.caption)
                                    Spacer()
                                }
                                
                                VStack{
                                    Spacer()
                                    Text(TransactionsTexts.taxaMaiusculo)
                                        .font(.footnote)
                                        .foregroundColor(Color.cinza)
                                    Spacer()
                                    Spacer()
                                    Text("\(Int(transactions.fee)) \(Texts.sat)")
                                        .font(.footnote)
                                        .foregroundColor(Color.cinza)
                                    Spacer()
                                }
                                
                            }.padding()
                                .frame(maxWidth: .infinity, maxHeight: 71)
                                .background(Color.caixas).cornerRadius(7)
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
                .presentationBackground(Color.azul)
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
