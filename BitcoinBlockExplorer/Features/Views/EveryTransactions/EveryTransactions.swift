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
                EachAddressView(addressSearch: $addressSearch, abrirModalAddress: $abrirModalAddress)
                    .presentationBackground(Color.background)
            }
            .sheet(isPresented: $abrirModalTransaction) {
                EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction)
                    .presentationBackground(Color.background)
            }
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            .customToolbar()
            
            .background(Color.background)
        }
    }
}

struct EveryTransactions_Previews: PreviewProvider {
    static var previews: some View {
        EveryTransactions()
    }
}
