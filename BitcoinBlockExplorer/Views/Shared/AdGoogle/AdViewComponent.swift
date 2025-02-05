//
//  AdViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct AdViewComponent: View {
    @EnvironmentObject var addManager: AddManager
    @EnvironmentObject private var store: SubscriptionStore
    
    var body: some View {
        if addManager.bannerViewIsAdded == false || store.purschasedSubscriptions == true {
            VStack {
                RoundedRectangle(cornerRadius: 1).frame(width: 0.1, height: 0.1)
            }
        } else {
            addManager.addView
        }
    }
}

#Preview {
    return AdViewComponent()
        .environmentObject(AddManager())
        .environmentObject(SubscriptionStore())
}
