//
//  LightningWalletView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 13/06/24.
//

import SwiftUI

struct LightningWalletView: View {
    
    @State private var showToast: Bool = false
    
    private var lightningAddress = "lnbc1pjl46s3pp53syv8xsjr5cdvxdn46xcn6akslh8j3g0glwe8ufwfkppprcylxssdqqcqzzgxqyz5vqrzjqwnvuc0u4txn35cafc7w94gxvq5p3cu9dd95f7hlrh0fvs46wpvhdte89v8awfp9vuqqqqryqqqqthqqpysp575n5z9w582e5jan9fum4hc7a4wux3ck027dstam7veylphcpcgaq9qrsgq32fjyfnwelvgs24rvptdcax5k8zq5e69em0vlwty5cse5vgeq96zq7qvyrj4vjp5dfxkvms0rmpmwhf0mu2wsjq5t5q5z6havj36w5cpq80dea"
    
    var body: some View {
        ScrollView {
            
            Text(Texts.lightningTitle)
                .foregroundStyle(Color.primaryText)
                .font(.title)
                .bold()
            
            Spacer()
            
            Text(Texts.scanText2)
                .foregroundStyle(Color.texts)
                .minimumScaleFactor(0.6)
                .font(.title3)
                .padding(.horizontal)
            
            Image("lightningQRCode")
                .resizable()
                .padding()
                .scaledToFit()
            
            Text(lightningAddress)
                .foregroundStyle(Color.primaryText)
                .lineLimit(2)
                .padding(.horizontal)
            
            VStack{
                
                Text(Texts.copy)
                    .padding()
                    .foregroundStyle(Color.texts)
                    .onTapGesture {
                        UIPasteboard.general.string = lightningAddress
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                        }
                    }
                
            }.background(Color.backgroundBox)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
        }.padding()
            .background(Color.background)
        
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
    LightningWalletView()
}
