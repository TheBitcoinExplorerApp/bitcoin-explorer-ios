//
//  ContentView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        
        TabView{
            HomeView().tabItem {
                Label(ContentViewTexts.home, systemImage: "house")
            }.toolbarBackground(Color.background, for: .tabBar)
            
            EveryTransactions().tabItem {
                Label(TransactionsTexts.transacoesMaiusculo, systemImage: "rectangle.grid.1x2.fill")
            }.toolbarBackground(Color.background, for: .tabBar)
            
            ConfigurationsView().tabItem {
                Label(Texts.configuracoes, systemImage: "gearshape.fill")
            }.toolbarBackground(Color.background, for: .tabBar)
        }
        .accentColor(Color.primaryText)
                
    }
}

#Preview {
    return ContentView()
        .environmentObject(AddManager())
        .environmentObject(CurrencyComponentViewModel())
        .environmentObject(SubscriptionStore())
}
