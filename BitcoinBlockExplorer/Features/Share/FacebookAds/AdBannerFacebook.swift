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

class FBAdViewController: UIViewController, FBAdViewDelegate {
    private var adView: FBAdView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura o ad banner
        let adView = FBAdView(placementID: "2517385811796587_2531852100349958", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.frame = CGRect(x: 0, y: view.bounds.height - adView.frame.size.height, width: adView.frame.size.width, height: adView.frame.size.height)
        adView.delegate = self
        adView.loadAd(withBidPayload: "")
        self.adView = adView
    }

    // Delegate methods
    func adViewDidLoad(_ adView: FBAdView) {
        print("Ad was loaded and ready to be displayed")
        self.view.addSubview(adView)
    }

    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("Ad failed to load with error: \(error)")
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
