//
//  EveryTransactions.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct EveryTransactions: View {
    @StateObject var transactionData = TransactionData()
    @StateObject var validateAddresses = Validate()
    // using the search
    @State var addressSearch: String = ""
    @State var idTransacaoSearch: String = ""
    @State var abrirModalTransaction: Bool = false
    @State var abrirModalAddress: Bool = false
    @State var idTransacaoButton: String = ""
    @State var searchText: String = ""
    
    var body: some View {
        
        NavigationStack{
            ScrollView(.vertical) {
                BoxTransactions()
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
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

struct EveryTransactions_Previews: PreviewProvider {
    static var previews: some View {
        EveryTransactions()
    }
}
