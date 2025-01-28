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
                Blockchain()
                    .environmentObject(viewModel)
            }
        }
        
    }
    
}

#Preview {
    return HomeView()
        .environmentObject(CurrencyViewModel())
        .environmentObject(AddManager())
}
