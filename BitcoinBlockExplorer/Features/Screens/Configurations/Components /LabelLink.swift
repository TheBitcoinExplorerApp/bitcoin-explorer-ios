//
//  LabelLink.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/03/24.
//

import SwiftUI

struct LabelLink: View {

    let titleKey: String
    let destination: URL
    let systemImage: String

    init (_ titleKey: String, url: String, systemImage: String) {
        self.titleKey = titleKey
        self.destination = URL(string: url)!
        self.systemImage = systemImage
    }

    var body: some View {
        Label {
            HStack {
                Link(titleKey, destination: destination)
                    .foregroundStyle(Color.cinza)
                Spacer()
                Image(systemName: "link")
                    .foregroundColor(.secondary)
            }
        } icon: {
            Image(systemName: systemImage)
        }
    }

}
