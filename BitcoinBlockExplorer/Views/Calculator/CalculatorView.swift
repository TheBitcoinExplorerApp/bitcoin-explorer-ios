//
//  EveryTransactions.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct CalculatorView: View {
    
    var body: some View {
        
        ScrollView(.vertical) {
            BoxTransactions()
                .id(2)
        }
        .background(Color.myBackground)
 
        .titleToolbar()
        
    }
}

#Preview {
    CalculatorView()
}

#Preview {
    return ContentView()
        .environmentObject(AddManager())
        .environmentObject(CurrencyViewModel())
        .environmentObject(SubscriptionStore())
}
