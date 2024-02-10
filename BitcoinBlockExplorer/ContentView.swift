//
//  ContentView.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI

struct ContentView: View {
    
    private static let topId = "topIdHere"

       /*
         Use only for toggling, binding for external access or @State for internal access
       */
    @State var scrollToTopVar = false
    
    var body: some View {
        
        TabView{
            Home().tabItem {
                Label("Home", systemImage: "house")
            }.toolbarBackground(Color("azul"), for: .tabBar)
                
            EveryBlocks().tabItem {
                Label("Blocos", systemImage: "cube")
            }.toolbarBackground(Color("azul"), for: .tabBar)
            
            EveryTransactions().tabItem {
                Label("Transações", systemImage: "rectangle.grid.1x2.fill")
            }.toolbarBackground(Color("azul"), for: .tabBar)
        }
        .accentColor(Color("laranja"))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
