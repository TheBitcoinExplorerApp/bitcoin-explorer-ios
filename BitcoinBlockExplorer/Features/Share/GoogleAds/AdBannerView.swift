//
//  AdBannerView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 19/08/24.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {
    
    private let delegate: AdBannerViewDelegate
    @ObservedObject var addManager: AddManager
    
    init(addManager: AddManager) {
        self.addManager = addManager
        self.delegate = AdBannerViewDelegate(addManager: addManager)
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = ""
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        bannerView.delegate = context.coordinator
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
    
    func makeCoordinator() ->  AdBannerViewDelegate {
        AdBannerViewDelegate(addManager: self.addManager)
    }
    
}

class AddManager: ObservableObject {
    @Published var addView: AnyView?
    @Published var bannerViewIsAdded: Bool = true
    
    init() {
        addView = appearAd()
    }
    
    @ViewBuilder private func appearAd() -> AnyView {
        AnyView(
            AdBannerView(addManager: self)
                .frame(height: 60)
        )
    }
}

class AdBannerViewDelegate: NSObject, GADBannerViewDelegate {
    private var addManager: AddManager
    
    init(addManager: AddManager) {
        self.addManager = addManager
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.addManager.bannerViewIsAdded = true
        print("Received ad")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: any Error) {
        print("Failed to receive ad with error: \(error)")
        addManager.bannerViewIsAdded = false
    }
}
