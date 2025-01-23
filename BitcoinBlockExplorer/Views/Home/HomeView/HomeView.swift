//
//  HomeView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    @State var inRefresh: Bool = false
    
    // Search variables
    @StateObject var validateAddresses = Validate()
    @State var addressSearch: String = ""
    @State var idTransacaoSearch: String = ""
    @State var abrirModalAddress: Bool = false
    @State var abrirModalTransaction: Bool = false
    @State var idTransacaoButton: String = ""
    @State var searchText = ""
    
    var body: some View {
        
        VStack{
            ScrollView{
                home
                    .id(1)
            }
            
            .refreshable {
                self.inRefresh = true
                viewModel.getFees()
                viewModel.getBlockHeader(50)
            }
            
            AdViewComponent()
            
        }
        
        .task {
            viewModel.getFees()
            viewModel.getBlockHeader(50)
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
        
        .titleToolbar()
        
        .background(Color.background)
                
    }
    
    var home: some View {
        VStack {
            if viewModel.loading && !inRefresh {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                
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
                
                BoxBlocks(blocks: viewModel.blockHeaderData)
                
            }
        }
        
    }
}

#Preview {
   return HomeView()
        .environmentObject(CurrencyComponentViewModel())
        .environmentObject(AddManager())
}
