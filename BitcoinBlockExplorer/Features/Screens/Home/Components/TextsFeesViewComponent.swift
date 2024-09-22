//
//  TextsFeesViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct TextsFeesViewComponent: View {
    var body: some View {
        VStack{
            Text(HomeTexts.taxasDeTransacao).foregroundStyle(Color.cinza)
                .bold()
                .font(.headline)
            
            HStack {
                
                Spacer()
                
                Text(HomeTexts.baixaPrioridade).foregroundStyle(Color.cinza).font(.footnote)
                
                Spacer()
                
                Text(HomeTexts.mediaPrioridade).foregroundStyle(Color.cinza).font(.footnote)
                
                Spacer()
                
                Text(HomeTexts.altaPrioridade).foregroundStyle(Color.cinza).font(.footnote)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.caixas)
            .cornerRadius(7)
        }.padding(.horizontal)
    }
}

#Preview {
    TextsFeesViewComponent()
}
