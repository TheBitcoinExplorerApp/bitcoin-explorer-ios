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
            Text(Texts.taxasDeTransacao).foregroundStyle(Color.texts)
                .bold()
                .font(.headline)
            
            HStack {
                
                Spacer()
                
                Text(Texts.baixaPrioridade).foregroundStyle(Color.texts).font(.footnote)
                
                Spacer()
                
                Text(Texts.mediaPrioridade).foregroundStyle(Color.texts).font(.footnote)
                
                Spacer()
                
                Text(Texts.altaPrioridade).foregroundStyle(Color.texts).font(.footnote)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
        }.padding(.horizontal)
    }
}

#Preview {
    TextsFeesViewComponent()
}
