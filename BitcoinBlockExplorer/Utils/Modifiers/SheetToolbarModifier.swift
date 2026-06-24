//
//  SheetToolbarModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 22/01/25.
//

import SwiftUI

struct SheetToolbarModifier: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    var title: String = ""
    
    func body(content: Content) -> some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if #available(iOS 26, *) {
                            Button(role: .close) { dismiss() }
                        } else {
                            Button{
                                dismiss()
                            } label: {
                                Circle()
                                    .fill()
                                    .foregroundStyle(Color.dismissBackground)
                                    .frame(width: 30, height: 30)
                                    .overlay() {
                                        Text("X")
                                            .clipShape(Circle())
                                            .font(.system(size: 22.5))
                                            .foregroundColor(Color.primaryText)
                                    }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .foregroundStyle(Color.texts)
                            .bold()
                            .font(.headline)
                    }
                }
                .toolbarBackgroundIfNeeded(Color.myBackground)
        }
    }
}

extension View {
    func sheetToolbar(title: String) -> some View {
        self.modifier(SheetToolbarModifier(title: title))
    }
}
