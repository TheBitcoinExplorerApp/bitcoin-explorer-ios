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

    @State private var tabSelection = 1
    @State private var tappedTwice: Bool = false
    
    @SceneStorage("selectedTab") var selectedTab = 0
    
    var body: some View {
        
        return ScrollViewReader { proxy in
            if #available(iOS 26.0, *) {
                TabView(selection: $selectedTab) {
                    Tab(Texts.blockchain, systemImage: "cube.fill", value: 1) {
                        NavigationStack {
                            BlockchainView()
                                .onChange(of: tappedTwice, perform: { tapped in
                                    if tapped {
                                        withAnimation {
                                            proxy.scrollTo(1, anchor: .top)
                                        }
                                        tappedTwice = false
                                    }
                                })
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
//                .tabViewSearchActivation(.searchTabSelection)
                .accentColor(Color.primaryText)
            }
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
