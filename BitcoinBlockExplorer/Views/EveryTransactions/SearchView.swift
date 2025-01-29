//
//  EveryTransactions.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct SearchView: View {
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
        
        ScrollView(.vertical) {
            BoxTransactions()
                .id(2)
        }
        .background(Color.background)
        
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Texts.searchPlaceholder) {
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
            EachAddressView(addressSearch: $addressSearch, abrirModalAddress: $abrirModalAddress)
                .presentationBackground(Color.background)
        }
        .sheet(isPresented: $abrirModalTransaction) {
            EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction)
                .presentationBackground(Color.background)
        }
        
        .titleToolbar()
        
    }
}

#Preview {
    SearchView()
}
