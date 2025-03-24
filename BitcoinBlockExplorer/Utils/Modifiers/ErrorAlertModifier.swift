//
//  ErrorAlertModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 03/02/25.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    var showAlert: Binding<Bool>
    var errorMessage: Binding<Errors?>

    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage.wrappedValue?.errorDescription ?? "Unknown error")
            }
    }
}

extension View {
    func errorAlert(showAlert: Binding<Bool>, errorMessage: Binding<Errors?>) -> some View {
           self.modifier(ErrorAlertModifier(showAlert: showAlert, errorMessage: errorMessage))
       }
}
