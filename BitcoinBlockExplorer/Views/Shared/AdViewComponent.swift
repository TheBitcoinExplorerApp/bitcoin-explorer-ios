//
//  AdViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct AdViewComponent: View {
    @EnvironmentObject var addManager: AddManager
    
    var body: some View {
        if addManager.bannerViewIsAdded == false {
            VStack {
                RoundedRectangle(cornerRadius: 1).frame(width: 0.1, height: 0.1)
            }
        } else {
            addManager.addView
        }
    }
}

#Preview {
    let addManager = AddManager()
    return AdViewComponent()
        .environmentObject(addManager)
}
