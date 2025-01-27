//
//  HomeView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @EnvironmentObject var currencyViewModel:  CurrencyViewModel
    
    // Search variables
    @StateObject var validateAddresses = Validate()
    @State var addressSearch: String = ""
    @State var idTransacaoSearch: String = ""
    @State var abrirModalAddress: Bool = false
    @State var abrirModalTransaction: Bool = false
    @State var idTransacaoButton: String = ""
    @State var searchText = ""
    
    var body: some View {
        
        VStack {
            ScrollView{
                home
                    .id(1)
            }
            .refreshable {
                viewModel.getFees()
                viewModel.getBlockHeader(50)
                viewModel.getMempool()
                viewModel.getMempoolSize()
                currencyViewModel.getCoins()
            }
            
            AdViewComponent()
        }
        .task {
            viewModel.getFees()
            viewModel.getBlockHeader(50)
            viewModel.getMempool()
            viewModel.getMempoolSize()
        }
        
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: ToolbarTexts.searchPlaceholder) {}
        
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
            }.padding(.vertical)
            if viewModel.loading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                if let mempool = viewModel.mempoolData {
                    Blockchain(blocks: viewModel.blockHeaderData, mempoolData: mempool, mempoolSize: viewModel.getTotalMempoolSize(), mempoolVSize: viewModel.getTotalMempoolVSize())
                }
            }
        }
        
    }
}

#Preview {
    return HomeView()
        .environmentObject(CurrencyViewModel())
        .environmentObject(AddManager())
}
