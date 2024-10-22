//
//  TesteAPIApp.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI
import GoogleMobileAds
import FBAudienceNetwork

@main
struct BitcoinBlockExplorerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var addManager = AddManager()
    @StateObject var currencyViewModel = CurrencyComponentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(addManager)
                .environmentObject(currencyViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        FBAudienceNetworkAds.initialize(with: nil, completionHandler: nil)
        // Pass user's consent after acquiring it. For sample app purposes, this is set to YES.
        FBAdSettings.setAdvertiserTrackingEnabled(true)
        
        return true
    }
}
