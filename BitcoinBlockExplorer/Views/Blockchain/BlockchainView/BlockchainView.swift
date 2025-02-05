//
//  BlockchainView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct BlockchainView: View {
    @EnvironmentObject var viewModel: BlockchainViewModel
    @EnvironmentObject var lastBlockViewModel: LastBlockViewModel
    @EnvironmentObject var currencyViewModel:  CurrencyViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
  
    var body: some View {
        
        VStack {
            SearchView()
            
            ScrollView{
                blockchainView
                    .id(1)
            }
            .refreshable {
                viewModel.fetchFees()
                viewModel.fetchBlockHeader(50)
                viewModel.fetchMempoolData()
                viewModel.fetchMempoolSize()
                currencyViewModel.fetchCoins()
                lastBlockViewModel.fetchLastBlock()
                viewModel.getFullNodes()
                viewModel.fetchHashrate()
                viewModel.fetchBlockReward()
                viewModel.fetchDifficultyAdjustment()
            }
            
#warning("comentado o add")
//            AdViewComponent()
        }
        
        .errorAlert(showAlert: $viewModel.showErrorAlert)
        .errorAlert(showAlert: $lastBlockViewModel.showErrorAlert)

        .titleToolbar()
        
        .background(Color.myBackground)
        
    }
    
    var blockchainView: some View {
        VStack {
            if networkMonitor.isConnected {
                
                BitcoinPriceViewComponent()
                fees
                blockchain
                HalvingView()
                DifficultyAdjustmentView()
                    .padding(.bottom)
            
                HStack {
                    FullNodesView()
                    Spacer()
                    HashrateView()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                BlockRewardView()
                
            } else {
                NetworkConnectionView()
            }
        }
    }
    
    var blockchain: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                MempoolBlocksView()
            }
        }
    }
    
    var fees: some View {
        VStack{
            TextsFeesViewComponent()
            VStack(alignment: .center) {
                ForEach(viewModel.fees, id: \.self) { fee in
                    HStack(spacing: 17) {
                        BlockchainFeeViewComponent(fee: fee.hourFee)
                        BlockchainFeeViewComponent(fee: fee.halfHourFee)
                        BlockchainFeeViewComponent(fee: fee.fastestFee)
                    }
                }
            }
        }
        .padding(.vertical)
        .task {
            viewModel.fetchFees()
        }
    
    }
    
}

#Preview {
    return BlockchainView()
        .environmentObject(CurrencyViewModel())
        .environmentObject(AddManager())
        .environmentObject(LastBlockViewModel())
        .environmentObject(BlockchainViewModel())
        .environmentObject(NetworkMonitor())
        .environmentObject(SubscriptionStore())
}
