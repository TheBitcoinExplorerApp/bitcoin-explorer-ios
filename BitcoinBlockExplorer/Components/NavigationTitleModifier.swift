//
//  NavigationTitleModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/03/24.
//

import SwiftUI

struct NavigationBarTitleColorModifier: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        
        content
            .onAppear() {
                
                let coloredAppearance = UINavigationBarAppearance()
                
                coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                
                UINavigationBar.appearance().standardAppearance = coloredAppearance
                
            }
        
    }
    
}

extension View {
    func navigationBarTitleColor(_ color: Color) -> some View {
        return self.modifier(NavigationBarTitleColorModifier(color: color))
    }
}
