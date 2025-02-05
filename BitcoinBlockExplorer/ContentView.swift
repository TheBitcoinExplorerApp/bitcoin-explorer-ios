//
//  ContentView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = BlockchainViewModel()
    
    @State private var tabSelection = 1
    @State private var tappedTwice: Bool = false
    
    var body: some View {
        
        var handler: Binding<Int> { Binding(
                get: { self.tabSelection },
                set: {
                    if $0 == self.tabSelection {
                        // Lands here if user tapped more than once
                        tappedTwice = true
                    }
                    self.tabSelection = $0
                }
        )}
        
        return ScrollViewReader { proxy in
            TabView(selection: handler) {
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
                .tabItem {
                    Label(Texts.blockchain, systemImage: "cube.fill")
                }
                .toolbarBackground(Color.myBackground, for: .tabBar)
                .tag(1)
                
                NavigationStack {
                    CalculatorView()
                        .onChange(of: tappedTwice, perform: { tapped in
                            if tapped {
                                withAnimation {
                                    proxy.scrollTo(2, anchor: .top)
                                }
                                tappedTwice = false
                            }
                        })
                }
                .tabItem {
                    Label(Texts.search, systemImage: "magnifyingglass")
                }
                .toolbarBackground(Color.myBackground, for: .tabBar)
                .tag(2)
                
                NavigationStack {
                    ConfigurationsView()
                }
                .tabItem {
                    Label(Texts.configuracoes, systemImage: "gearshape.fill")
                }
                .toolbarBackground(Color.myBackground, for: .tabBar)
                .tag(3)
                
            }
            .accentColor(Color.primaryText)
        }
        
    }
}

#Preview {
    return ContentView()
        .environmentObject(AddManager())
        .environmentObject(CurrencyViewModel())
        .environmentObject(SubscriptionStore())
        .environmentObject(LastBlockViewModel())
        .environmentObject(NetworkMonitor())
}
