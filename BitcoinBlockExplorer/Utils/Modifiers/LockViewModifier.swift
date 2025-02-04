//
//  LockViewModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/02/25.
//



import SwiftUI

struct LockViewModifier: ViewModifier {
    
    @EnvironmentObject private var store: SubscriptionStore
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if store.purschasedSubscriptions == false {
                    LockView()
                }
            }
    }
}

extension View {
    func lockView() -> some View {
        self.modifier(LockViewModifier())
    }
}
