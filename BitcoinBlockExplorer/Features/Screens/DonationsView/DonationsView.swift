//
//  DonationsView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/03/24.
//

import SwiftUI

struct DonationsView: View {
    var body: some View {
        
        TabView {
            
            BitcoinWalletView()
            
            LightningWalletView()
            
        }.background(Color.azul)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct BitcoinWalletView: View {
    
    @State private var showToast: Bool = false
    
    private var bitcoinAddress: String = "bc1pfyd5ksndyzhygt2e2kvt89ry30aaa9256pfqu7ys0hw249a7c8zsv0udqg"
    
    var body: some View {
        
            ScrollView {
                
                Text(Texts.bitcoinAddressTitle)
                    .font(.title)
                    .foregroundStyle(Color.laranja)
                    .bold()
                    
                Spacer()
                
                Text(Texts.scanText1)
                    .foregroundStyle(Color.cinza)
                    .font(.title3)
                    .minimumScaleFactor(0.1)
                
                Image("bitcoinQRCode")
                    .resizable()
                    .frame(width: 350, height: 350)
                    .scaledToFit()
                
                Text(bitcoinAddress)
                    .foregroundStyle(Color.laranja)
                    .lineLimit(1)
                    .padding(.horizontal)
                
                VStack{
                    
                    Text(Texts.copy)
                        .padding()
                        .foregroundStyle(Color.cinza)
                        .onTapGesture {
                            UIPasteboard.general.string = bitcoinAddress
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showToast = false
                            }
                        }
                    
                }.background(Color.caixas)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
            }.padding()
                .background(Color.azul)
            
                .overlay(
                    Group {
                        if showToast {
                            withAnimation() {
                                ToastView()
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .transition(.move(edge: .bottom))
                            }
                            
                        }
                    }
                )
            
                .scrollIndicators(.visible)
        
    }
}

struct LightningWalletView: View {
    
    @State private var showToast: Bool = false
    
    private var lightningAddress = "lnbc1pjl46s3pp53syv8xsjr5cdvxdn46xcn6akslh8j3g0glwe8ufwfkppprcylxssdqqcqzzgxqyz5vqrzjqwnvuc0u4txn35cafc7w94gxvq5p3cu9dd95f7hlrh0fvs46wpvhdte89v8awfp9vuqqqqryqqqqthqqpysp575n5z9w582e5jan9fum4hc7a4wux3ck027dstam7veylphcpcgaq9qrsgq32fjyfnwelvgs24rvptdcax5k8zq5e69em0vlwty5cse5vgeq96zq7qvyrj4vjp5dfxkvms0rmpmwhf0mu2wsjq5t5q5z6havj36w5cpq80dea"
    
    var body: some View {
        ScrollView {
            
            Text(Texts.lightningTitle)
                .foregroundStyle(Color.laranja)
                .font(.title)
                .bold()
            
            Spacer()
            
            Text(Texts.scanText2)
                .foregroundStyle(Color.cinza)
                .minimumScaleFactor(0.1)
                .font(.title3)
            
            Image("lightningQRCode")
                .resizable()
                .padding()
                .scaledToFit()
            
            Text(lightningAddress)
                .foregroundStyle(Color.laranja)
                .lineLimit(2)
                .padding(.horizontal)

            VStack{
                
                Text(Texts.copy)
                    .padding()
                    .foregroundStyle(Color.cinza)
                    .onTapGesture {
                        UIPasteboard.general.string = lightningAddress
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                        }
                    }
                
            }.background(Color.caixas)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
        }.padding()
            .background(Color.azul)
        
            .overlay(
                Group {
                    if showToast {
                        withAnimation() {
                            ToastView()
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .transition(.move(edge: .bottom))
                        }
                        
                    }
                }
            )
        
            .scrollIndicators(.visible)
        
    }
}

#Preview {
    DonationsView()
}
