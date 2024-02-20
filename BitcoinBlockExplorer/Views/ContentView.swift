//
//  ContentView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var localCoin: Double
    
    var body: some View {
        
        TabView{
            Home().tabItem {
                Label(ContentViewTexts.home, systemImage: "house")
            }.toolbarBackground(Color.azul, for: .tabBar)
            
            EveryBlocks().tabItem {
                Label(BlocksTexts.blocos, systemImage: "cube")
            }.toolbarBackground(Color.azul, for: .tabBar)
            
            EveryTransactions().tabItem {
                Label(TransactionsTexts.transacoesMaiusculo, systemImage: "rectangle.grid.1x2.fill")
            }.toolbarBackground(Color.azul, for: .tabBar)
            ConfigurationsView().tabItem {
                Label(Texts.configuracoes, systemImage: "gearshape.fill")
            }.toolbarBackground(Color.azul, for: .tabBar)
        }
        .accentColor(Color.laranja)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(localCoin: .constant(0))
    }
}
