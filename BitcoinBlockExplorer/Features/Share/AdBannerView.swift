//
//  AdBannerView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 19/08/24.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {
    let adUnitID: String
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: UIScreen().bounds.size.width, height: UIScreen().bounds.size.height)))
        bannerView.adUnitID = adUnitID
        bannerView.delegate = context.coordinator // Defina o delegate para o coordinator
        bannerView.isHidden = true // Comece com o banner oculto
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        var parent: AdBannerView
        
        init(_ parent: AdBannerView) {
            self.parent = parent
        }
        
        // Chamado quando o anúncio foi carregado com sucesso
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            bannerView.isHidden = false
        }
        
        // Chamado quando há uma falha no carregamento do anúncio
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to receive ad: \(error.localizedDescription)")
            bannerView.isHidden = true
        }
    }
    
}
