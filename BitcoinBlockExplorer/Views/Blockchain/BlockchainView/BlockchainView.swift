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
                viewModel.fetchBlockHeader(50)
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
            if viewModel.blockHeaderData.isEmpty {
                viewModel.fetchFees()
                viewModel.fetchBlockHeader(50)
                viewModel.fetchMempoolData()
                viewModel.fetchMempoolSize()
            }

            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                guard !Task.isCancelled else { break }
                viewModel.fetchFees()
                viewModel.fetchBlockHeader(50)
                viewModel.fetchMempoolData()
                viewModel.fetchMempoolSize()
                lastBlockViewModel.fetchLastBlock()
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
                        .padding()
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
