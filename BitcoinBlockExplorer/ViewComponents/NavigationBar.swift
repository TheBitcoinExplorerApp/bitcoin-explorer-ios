//
//  NavigationBar.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/07/23.
//

import SwiftUI

struct NavigationBar: View {
  
  @StateObject var validateAddresses = Validate()
  @State var addressSearch: String = ""
  @State var abrirModalAddress: Bool = false
  @State var abrirModalTransaction: Bool = false
  @State var idTransacaoButton: String = ""
  @State var idTransacaoSearch: String = ""
  @State var transacaoSearch: String = ""
  @State var searchText = ""
  
  var body: some View {
    
    NavigationStack{
      VStack{
        
      }
//      .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Blocos, transações ou endereços") {
//      }
//      .onSubmit(of: .search) {
//        if validateAddresses.isValidAddress(searchText){
//          addressSearch = searchText
//          abrirModalAddress.toggle()
//          
//        } else {
//          transacaoSearch = searchText
//          abrirModalTransaction.toggle()
//        }
//      }
      
//      .sheet(isPresented: $abrirModalAddress ) {
//        EachAddress(addressSearch: $addressSearch, abrirModalAddress: $abrirModalAddress).presentationDetents([.height(650), .fraction(0.90)])
//          .presentationBackground(Color("azul"))
//      }
//      .sheet(isPresented: $abrirModalTransaction) {
//        EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction).presentationDetents([.height(650), .fraction(0.90)])
//          .presentationBackground(Color("azul"))
//      }
      
//      .navigationBarTitleDisplayMode(.inline)
//      .toolbar {
//        ToolbarItem(placement: .navigationBarLeading) {
//          Image("bitcoinIcone").resizable().frame(width: 40, height: 40)
//        }
//        ToolbarItem(placement: .principal) {
//          Text("Bitcoin Block Explorer").foregroundColor(Color("laranja")).bold().font(.system(size: 20))
//        }
//      }
//      .toolbarBackground(Color("azul"), for: .navigationBar)
      
    }
    
  }
}

struct NavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    NavigationBar()
  }
}
