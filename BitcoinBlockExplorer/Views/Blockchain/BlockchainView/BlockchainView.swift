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
            if #available(iOS 26.0, *) {} else {
                SearchView()
            }
            
            ScrollView{
                blockchainView
                    .id(1)
            }
            .refreshable {
                viewModel.fetchFees()
                viewModel.fetchBlockHeader(15)
                viewModel.fetchMempoolData()
                viewModel.fetchMempoolSize()
                currencyViewModel.fetchCoins()
                lastBlockViewModel.fetchLastBlock()
                // viewModel.getFullNodes()
                viewModel.fetchHashrate()
                viewModel.fetchBlockReward()
                viewModel.fetchDifficultyAdjustment()
                viewModel.fetchBlockchainSupply()
            }
            
            if #available(iOS 26.0, *) {} else {
                AdViewComponent()
            }
            
        }
        
        .task {
            if viewModel.fees.isEmpty {
                viewModel.fetchFees()
            }
            
            if viewModel.mempoolData == nil {
                viewModel.fetchMempoolData()
            }
            
            if viewModel.mempoolSize.isEmpty {
                viewModel.fetchMempoolSize()
            }
            
            if viewModel.blockHeaderData.isEmpty {
                viewModel.fetchBlockHeader(15)
            }
        }
        
        .errorAlert(showAlert: $viewModel.showErrorAlert, errorMessage: $viewModel.errorType)
        .errorAlert(showAlert: $lastBlockViewModel.showErrorAlert, errorMessage: $viewModel.errorType)
        
        .titleToolbar()
        
        .background(Color.myBackground)
        
    }
    
    var blockchainView: some View {
        VStack {
            if networkMonitor.isConnected {
                
                BitcoinPriceViewComponent()
                fees
                
                if #available(iOS 26.0, *) {
                    AdViewComponent()
                        .padding(.horizontal)
                } else {}
                
                blockchain
                HalvingView()
                DifficultyAdjustmentView()
                    .padding(.bottom)
                
                HStack {
                    // FullNodesView()
                    // Spacer()
                    HashrateView()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                SupplyView()
                BlockRewardView()
                
            } else {
                NetworkConnectionView()
            }
        }
    }
    
    var blockchain: some View {
        VStack {
            if viewModel.loading && viewModel.blockHeaderData.isEmpty {
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
