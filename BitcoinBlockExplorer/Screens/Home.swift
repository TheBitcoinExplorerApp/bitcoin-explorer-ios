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
  @State var addressSearch: String = ""
  @State var idTransacaoSearch: String = ""
  @State var abrirModalAddress: Bool = false
  @State var abrirModalTransaction: Bool = false
  @State var idTransacaoButton: String = ""
  @State var searchText = ""
  
  var body: some View {
    NavigationStack{
      
      VStack{
        
        //NavigationBar()
        
        ScrollView{
          
          VStack{
            VStack{
              Text("Taxas de transação").foregroundColor(Color("cinza")).bold()
                .font(.system(size: 17))
              
              HStack{
                Text("Baixa Prioridade").foregroundColor(Color("cinza")).font(.system(size: 13))
                Text("Media Prioridade").foregroundColor(Color("cinza")).font(.system(size: 13))
                Text("Alta Prioridade").foregroundColor(Color("cinza")).font(.system(size: 13))
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color("caixas"))
              .cornerRadius(7)
            }.padding(.horizontal)
            
            VStack(alignment: .center){
              ForEach(feeData.fees, id: \.self) { fee in
                
                HStack(spacing: 17){
                  
                  HStack{
                    Text("\(fee.hourFee) sat/vB").foregroundColor(Color("cinza")).font(.system(size: 13))
                  }.padding()
                    .background(Color("caixas")).cornerRadius(7)
                  
                  HStack{
                    Text("\(fee.halfHourFee) sat/vB").foregroundColor(Color("cinza")).font(.system(size: 13))
                  }.padding()
                    .background(Color("caixas")).cornerRadius(7)
                  
                  HStack{
                    Text("\(fee.fastestFee) sat/vB").foregroundColor(Color("cinza")).font(.system(size: 13))
                  }.padding()
                    .background(Color("caixas")).cornerRadius(7)
                }
                
              }
            }
            
          }.padding(.vertical)
          BoxBlocks()
          
          BoxTransactions()
          
        }.scrollIndicators(.hidden)
        
      }
      .onAppear {
        feeData.getFees()
      }
      
      .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Blocos, transações ou endereços") {
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
        EachAddress(addressSearch: $addressSearch, abrirModalAddress: $abrirModalAddress).presentationDetents([.height(650), .fraction(0.90)])
          .presentationBackground(Color("azul"))
      }
      .sheet(isPresented: $abrirModalTransaction) {
        EachTransaction(idTransacaoButton: $idTransacaoButton, idTransacaoSearch: $idTransacaoSearch, abrirModalTransaction: $abrirModalTransaction).presentationDetents([.height(650), .fraction(0.90)])
          .presentationBackground(Color("azul"))
      }
      
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Image("bitcoinIcone").resizable().frame(width: 40, height: 40)
        }
        ToolbarItem(placement: .principal) {
          Text("Bitcoin Block Explorer").foregroundColor(Color("laranja")).bold().font(.system(size: 20))
        }
      }
      .toolbarBackground(Color("azul"), for: .navigationBar)
      
      .background(Color("azul"))
    }
    
  }
  
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
