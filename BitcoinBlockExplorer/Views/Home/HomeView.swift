//
//  HomeView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var validateAddresses = Validate()
    @StateObject var viewModel = HomeViewModel()
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
                    BitcoinPriceViewComponent()
                    VStack{
                        TextsFeesViewComponent()
                        VStack(alignment: .center) {
                            ForEach(viewModel.fees, id: \.self) { fee in
                                HStack(spacing: 17) {
                                    
                                    HomeFeeViewComponent(fee: fee.hourFee)
                                    
                                    HomeFeeViewComponent(fee: fee.halfHourFee)
                                    
                                    HomeFeeViewComponent(fee: fee.fastestFee)
                                    
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    BoxBlocks()
                    BoxTransactions()
                }
                
                AdViewComponent()
                
            }
            
            .task {
                viewModel.getFees()
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

#Preview {
    let vm = CurrencyComponentViewModel()
    let addManager = AddManager()
    return HomeView()
        .environmentObject(vm)
        .environmentObject(addManager)
}
