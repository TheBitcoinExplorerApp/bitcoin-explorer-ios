//
//  ContentView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI

struct ContentView: View {
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
                    HomeView()
                        .onChange(of: tappedTwice, perform: { tapped in
                            if tapped {
                                withAnimation {
                                    proxy.scrollTo(1, anchor: .top)
                                }
                                tappedTwice = false
                            }
                        })
                }
                .tabItem {
                    Label(ContentViewTexts.home, systemImage: "house")
                }
                .toolbarBackground(Color.background, for: .tabBar)
                .tag(1)
                
                NavigationStack {
                    EveryTransactions()
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
                    Label(TransactionsTexts.transacoesMaiusculo, systemImage: "rectangle.grid.1x2.fill")
                }
                .toolbarBackground(Color.background, for: .tabBar)
                .tag(2)
                
                NavigationStack {
                    ConfigurationsView()
                }
                .tabItem {
                    Label(Texts.configuracoes, systemImage: "gearshape.fill")
                }
                .toolbarBackground(Color.background, for: .tabBar)
                .tag(3)
                
            }
            .accentColor(Color.primaryText)
        }
        
    }
}

#Preview {
    return ContentView()
        .environmentObject(AddManager())
        .environmentObject(CurrencyComponentViewModel())
        .environmentObject(SubscriptionStore())
}


struct TesteView: View {
    
    var body: some View {
        ScrollView {
            ForEach(0..<1000) { n in
                Text("\(n)")
            }
        }
        .scrollIndicators(.visible)
    }
}
