//
//  AdBannerFacebook.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 22/10/24.
//

import SwiftUI
import FBAudienceNetwork

struct FBAdBannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FBAdViewController {
        return FBAdViewController()
    }

    func updateUIViewController(_ uiViewController: FBAdViewController, context: Context) {}
    
}

class AddFacebookManager: ObservableObject {
    @Published var addView: AnyView?
//    @Published var bannerViewIsAdded: Bool = true
    
    init() {
        addView = appearAd()
    }
    
    @ViewBuilder private func appearAd() -> AnyView {
        AnyView(
            FBAdBannerView()
                .frame(height: 60)
        )
    }
}

class FBAdViewController: UIViewController, FBAdViewDelegate {
    private var adView: FBAdView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura o ad banner
        let adView = FBAdView(placementID: "", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        adView.delegate = self
        adView.loadAd(withBidPayload: "")
        self.adView = adView
    }

    // Delegate methods
    func adViewDidLoad(_ adView: FBAdView) {
        print("Ad was loaded and ready to be displayed")
        if let adView = adView as? UIView {
            self.view.addSubview(adView)
        }
    }

    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("Ad failed to load with error: \(error.localizedDescription)")
    }

    func adViewDidClick(_ adView: FBAdView) {
        print("Ad was clicked.")
    }

    func adViewDidFinishHandlingClick(_ adView: FBAdView) {
        print("Ad did finish click handling.")
    }

    func adViewWillLogImpression(_ adView: FBAdView) {
        print("Ad impression is being captured.")
    }
}
