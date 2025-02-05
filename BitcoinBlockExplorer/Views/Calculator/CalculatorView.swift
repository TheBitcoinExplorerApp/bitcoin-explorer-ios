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
            EmptyView()
                .id(2)
        }
        .background(Color.myBackground)
 
        .titleToolbar()
        
    }
}

#Preview {
    CalculatorView()
}
