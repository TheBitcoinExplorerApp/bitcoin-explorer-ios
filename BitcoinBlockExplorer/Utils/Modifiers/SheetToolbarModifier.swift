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
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundStyle(Color.texts)
                        .bold()
                        .font(.headline)
                }
            }.toolbarBackground(Color.myBackground, for: .navigationBar)
    }
}

extension View {
    func sheetToolbar(title: String) -> some View {
        self.modifier(SheetToolbarModifier(title: title))
    }
}
