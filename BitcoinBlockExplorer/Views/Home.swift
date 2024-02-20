//
//  Home.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct Home: View {
    @StateObject var validateAddresses = Validate()
    @StateObject var feeData = FeeData()
    
    @StateObject var coins = CoinsPriceData()
    
    let configs = Configurations.shared
    
    @State var addressSearch: String = ""
    @State var idTransacaoSearch: String = ""
    @State var abrirModalAddress: Bool = false
    @State var abrirModalTransaction: Bool = false
    @State var idTransacaoButton: String = ""
    @State var searchText = ""
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                ScrollView{
                    
                    CurrencyView(rate: 1)
                        .font(.title2)
                    
                    VStack{
                        VStack{
                            Text(HomeTexts.taxasDeTransacao).foregroundColor(Color.cinza)
                                .bold()
                                .font(.headline)
                            
                            HStack {
                                
                                Spacer()
                                
                                Text(HomeTexts.baixaPrioridade).foregroundColor(Color.cinza).font(.footnote)
                                
                                Spacer()
                                
                                Text(HomeTexts.mediaPrioridade).foregroundColor(Color.cinza).font(.footnote)
                                
                                Spacer()
                                
                                Text(HomeTexts.altaPrioridade).foregroundColor(Color.cinza).font(.footnote)
                                
                                Spacer()
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.caixas)
                            .cornerRadius(7)
                        }.padding(.horizontal)
                        
                        VStack(alignment: .center) {
                            ForEach(feeData.fees, id: \.self) { fee in
                                
                                HStack(spacing: 17) {
                                    
                                    VStack{
                                        Text("\(fee.hourFee) \(Texts.satVb)").foregroundColor(Color.cinza)
                                            .font(.footnote)
                                       
                                    }.padding()
                                        .background(Color.caixas).cornerRadius(7)
                                    
                                    VStack{
                                        Text("\(fee.halfHourFee) \(Texts.satVb)").foregroundColor(Color.cinza)
                                            .font(.footnote)
                                    }.padding()
                                        .background(Color.caixas).cornerRadius(7)
                                    
                                    VStack{
                                        Text("\(fee.fastestFee) \(Texts.satVb)").foregroundColor(Color.cinza)
                                            .font(.footnote)
                                    }.padding()
                                        .background(Color.caixas).cornerRadius(7)
                                }
                                
                            }
                        }
                        
                    }.padding(.vertical)
                    
                    BoxBlocks()
                    
                    BoxTransactions()
                    
                }
                
            }
            
            .task {
                coins.getCoinPrice(configs.currency)
                feeData.getFees()
            }
            
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: ToolbarTexts.searchPlaceholder) {
            }
            
            .onSubmit(of: .search) {
                
                if validateAddresses.isValidAddress(searchText){
                    addressSearch = searchText
                    abrirModalAddress.toggle()
                    
                } else {
                    idTransacaoSearch = searchText
                    abrirModalTransaction.toggle()
                }
                
            }
            
            .sheet(isPresented: $abrirModalAddress ) {
                EachAddress(addressSearch: $addressSearch, abrirModalAddress: $abrirModalAddress)
                    .presentationBackground(Color.azul)
            }
            
            .sheet(isPresented: $abrirModalTransaction) {
                EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction)
                    .presentationBackground(Color.azul)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(ToolbarTexts.bitcoinIcone)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                ToolbarItem(placement: .principal) {
                    Text(ToolbarTexts.titleOfTheApp)
                        .foregroundColor(Color.laranja)
                        .bold()
                        .font(.title3)
                }
            }
            .toolbarBackground(Color.azul, for: .navigationBar)
            
            .background(Color.azul)
        }
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
