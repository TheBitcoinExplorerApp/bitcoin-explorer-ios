//
//  NetworkConnectionView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 01/02/25.
//

import SwiftUI

struct NetworkConnectionView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray)
                .padding(50)
            
            Text(Texts.internetConnectionLabel)
                .font(.title2)
                .foregroundStyle(.primaryText)
            
        }
        .padding()
        .background(Color.myBackground)
    }
}

#Preview {
    NetworkConnectionView()
}
