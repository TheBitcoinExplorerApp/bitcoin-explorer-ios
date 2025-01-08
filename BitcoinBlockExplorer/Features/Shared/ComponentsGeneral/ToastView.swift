//
//  ToastView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/03/24.
//

import SwiftUI

struct ToastView: View {
    
    var body: some View {
        VStack {
            HStack{
                
                Image(systemName: "clipboard.fill")
                    .padding(.vertical)
                
                Text(Texts.copied)
                    .foregroundColor(Color.texts)
                
            }
            .padding(.horizontal)
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    ToastView()
}
