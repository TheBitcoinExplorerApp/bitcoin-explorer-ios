//
//  BitcoinWalletView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 13/06/24.
//

import SwiftUI

struct BitcoinWalletView: View {
    
    @State private var showToast: Bool = false
    
    private var bitcoinAddress: String = "bc1pfyd5ksndyzhygt2e2kvt89ry30aaa9256pfqu7ys0hw249a7c8zsv0udqg"
    
    var body: some View {
        
        ScrollView {
            
            Text(Texts.bitcoinAddressTitle)
                .font(.title)
                .foregroundStyle(Color.primaryText)
                .bold()
            
            Spacer()
            
            Text(Texts.scanText1)
                .foregroundStyle(Color.texts)
                .font(.title3)
                .minimumScaleFactor(0.6)
                .padding(.horizontal)
            
            Image("bitcoinQRCode")
                .resizable()
                .padding()
                .scaledToFit()
            
            Text(bitcoinAddress)
                .foregroundStyle(Color.primaryText)
                .lineLimit(1)
                .padding(.horizontal)
            
            VStack{
                
                Text(Texts.copy)
                    .padding()
                    .foregroundStyle(Color.texts)
                    .onTapGesture {
                        UIPasteboard.general.string = bitcoinAddress
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                        }
                    }
                
            }.background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
        }.padding()
            .background(Color.myBackground)
        
            .overlay(
                Group {
                    if showToast {
                        withAnimation() {
                            ToastView()
                                .frame(maxHeight: .infinity, alignment: .center)
                                .transition(.move(edge: .bottom))
                        }
                        
                    }
                }
            )
        
            .scrollIndicators(.visible)
        
    }
}

#Preview {
    BitcoinWalletView()
}
