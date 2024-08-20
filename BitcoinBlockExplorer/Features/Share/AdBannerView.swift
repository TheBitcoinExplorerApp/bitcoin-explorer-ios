//
//  AdBannerView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 19/08/24.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3489866247738033/3403960018"
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
    
}

class AddManager: ObservableObject {
    @Published var addView: AnyView?
    
    init() {
        addView = appearAd()
    }
    
    @ViewBuilder private func appearAd() -> AnyView {
        AnyView(
            AdBannerView()
                .frame(height: 60)
        )
    }
}
