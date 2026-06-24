//
//  ContentViewLiquidGlass.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 12/11/25.
//

import SwiftUI

struct ContentViewLiquidGlass: View {
    @StateObject var viewModel = BlockchainViewModel()
    @StateObject var searchModel = SearchModel()
    
    @SceneStorage("selectedTab") var selectedTab = 0
    
    var body: some View {
        
        if #available(iOS 26.0, *) {
            TabView(selection: $selectedTab) {
                Tab(Texts.blockchain, systemImage: "cube.fill", value: 1) {
                    NavigationStack {
                        BlockchainView()
                            .environmentObject(viewModel)
                    }
                    .tag(1)
                }
                
                Tab(value: 2) {
                    NavigationStack {
                        CalculatorView()
                    }
                    .tag(2)
                } label: {
                    Label {
                        Text(Texts.calculator)
                    } icon: {
                        Image("calculatorIcon")
                            .renderingMode(.template)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                
                Tab(Texts.configuracoes, systemImage: "gearshape.fill", value: 3) {
                    
                    NavigationStack {
                        ConfigurationsView()
                    }
                    .tag(3)
                    
                }
                
                Tab(value: 4, role: .search) {
                    NavigationStack {
                        SearchTabView(model: searchModel)
                    }
                    .tag(4)
                }
                
            }
            .accentColor(Color.primaryText)
        }
        
    }
}

#Preview {
    return ContentViewLiquidGlass()
        .environmentObject(AddManager())
        .environmentObject(CurrencyViewModel())
        .environmentObject(SubscriptionStore())
        .environmentObject(LastBlockViewModel())
        .environmentObject(NetworkMonitor())
}
