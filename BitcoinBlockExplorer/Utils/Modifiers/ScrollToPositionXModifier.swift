//
//  ScrollToPositionXModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 14/02/25.
//

import SwiftUI

struct ScrollToPositionXModifier: ViewModifier {
    
    @State private var showButtonScrollToStart: Bool = false
    
    func body(content: Content) -> some View {
        
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                content
                    .id("start1")
                
                    .background(
                        GeometryReader { inner in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: inner.frame(in: .global).origin.x)
                        }
                    )
                
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        let threshold: CGFloat = -100
                        showButtonScrollToStart = value < threshold
                    }
            }
            .overlay(alignment: .bottomTrailing) {
                if showButtonScrollToStart {
                    Button(action: {
                        withAnimation {
                            proxy.scrollTo("start1", anchor: .leading)
                        }
                    }) {
                        Image(systemName: "arrow.left.to.line.alt")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.primaryText)
                            .opacity(0.9)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
            
        }
        
    }
}

extension View {
    func scrollToBeginX() -> some View {
        self.modifier(ScrollToPositionXModifier())
    }
}
