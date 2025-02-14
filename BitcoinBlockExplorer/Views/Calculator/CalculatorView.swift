//
//  EveryTransactions.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 16/05/23.
//

import SwiftUI

struct CalculatorView: View {
    let apiHandler = APIHandler()
    
    @State var cameFromOther: Bool = false
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @EnvironmentObject private var store: SubscriptionStore
    @State private var showSubscriptionView: Bool = false
    
    @State var btcValue: String = ""
    @State var fiatValue: String = ""
    @State var satsValue: String = ""
    
    @FocusState var isFocusedInBTC: Bool
    @FocusState var isFocusedInFiat: Bool
    @FocusState var isFocusedInSats: Bool
    
    @State var price: Double = 0
    @State var flag: String = ""
    @State var symbol: String = ""
    @State var ticker: String = ""
    
    @AppStorage("selectedCoin") private var selectedCoin = 0
    
    @AppStorage("currencyCoin") var currencyCoin: Int = 0 {
        didSet {
            self.fetchCoins {
                self.convertPrice()
            }
        }
    }
    
    let currencies = ["🇺🇸 USD", "🇪🇺 EUR", "🇬🇧 GBP", "🇨🇦 CAD", "🇨🇭 CHF", "🇦🇺 AUD", "🇯🇵 JPY", "🇧🇷 BRL", "🇨🇳 CNY", "🇷🇺 RUB"]
    
    var body: some View {
        VStack {
            if networkMonitor.isConnected {
                
                calculator
                
                if store.purschasedSubscriptions == false {
                    Form {
                        Section {
                            VStack {
                                Text(Texts.beProCalculatorLabel)
                                    .font(.title2)
                                    .foregroundStyle(Color.texts)
                                    .padding()
                                
                                Button {
                                    showSubscriptionView.toggle()
                                } label: {
                                    Text(Texts.subscribe)
                                        .font(.title)
                                        .bold()
                                }
                                .tint(Color.primaryText)
                                .buttonStyle(.bordered)
                            }
                        }
                        .listRowBackground(Color.backgroundBox)
                    }
                    .background(Color.myBackground)
                    .scrollContentBackground(.hidden)
                }
            } else {
                ScrollView {
                    NetworkConnectionView()
                }
            }
            
        }
        .background(Color.myBackground)
        
        .task {
            fetchCoins()
        }
        
        .titleToolbar()
        
        .sheet(isPresented: $showSubscriptionView) {
            StoreKitView(showSubscriptionView: $showSubscriptionView)
        }
    }
    
    private var calculator: some View {
        Form {
            Section {
                Picker(selection: $selectedCoin, label: Text(Texts.currencyLabel)
                    .foregroundStyle(Color.texts)) {
                        
                        ForEach(0 ..< self.currencies.count, id: \.self) { index in
                            Text(self.currencies[index])
                                .tag(index)
                                .foregroundStyle(Color.texts)
                        }
                        
                    }.onChange(of: selectedCoin) { newValue in
                        currencyCoin = newValue
                    }
            }
            .listRowBackground(Color.backgroundBox)
            
            Section {
                Label {
                    HStack {
                        
                        TextField(ticker, text: $fiatValue)
                            .font(.title3)
                            .bold()
                            .keyboardType(.decimalPad)
                            .focused($isFocusedInFiat)
                            .onChange(of: fiatValue) { _ in
                                if fiatValue.isEmpty {
                                    btcValue = ""
                                    satsValue = ""
                                }
                                convertPrice()
                            }
                        
                        if !fiatValue.isEmpty && isFocusedInFiat {
                            Button {
                                btcValue = ""
                                fiatValue = ""
                                satsValue = ""
                            }label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 25, maxHeight: 25)
                            }
                            .tint(Color.gray)
                        }
                    }
                } icon: {
                    Text(flag)
                        .font(.title2)
                }
                
                Label {
                    HStack {
                        TextField("BTC", text: $btcValue)
                            .font(.title3)
                            .bold()
                            .keyboardType(.decimalPad)
                            .focused($isFocusedInBTC)
                            .onChange(of: btcValue) { _ in
                                if btcValue.isEmpty {
                                    fiatValue = ""
                                    satsValue = ""
                                }
                                convertPrice()
                            }
                        if !btcValue.isEmpty && isFocusedInBTC {
                            Button {
                                btcValue = ""
                                fiatValue = ""
                                satsValue = ""
                            }label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 25, maxHeight: 25)
                            }
                            .tint(Color.gray)
                        }
                    }
                } icon: {
                    Image("bitcoinIcone")
                        .renderingMode(.template)
                        .resizable()
                        .tint(Color.primaryText)
                        .frame(maxWidth: 20, maxHeight: 25)
                }
                
                Label {
                    HStack {
                        TextField(Texts.Sats, text: $satsValue)
                            .font(.title3)
                            .bold()
                            .keyboardType(.numberPad)
                            .focused($isFocusedInSats)
                            .onChange(of: satsValue) { _ in
                                if satsValue.isEmpty {
                                    btcValue = ""
                                    fiatValue = ""
                                }
                                convertPrice()
                            }
                        if !satsValue.isEmpty && isFocusedInSats {
                            Button {
                                btcValue = ""
                                fiatValue = ""
                                satsValue = ""
                            }label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 25, maxHeight: 25)
                            }
                            .tint(Color.gray)
                        }
                        
                    }
                } icon: {
                    Image("satoshiIcon")
                        .renderingMode(.template)
                        .resizable()
                        .tint(Color.primaryText)
                        .frame(maxWidth: 30, maxHeight: 30)
                }
            }
            .listRowBackground(Color.backgroundBox)
            
            Section {
                if isFocusedInBTC || isFocusedInFiat || isFocusedInSats {
                    Button(Texts.dismissKeyboard) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .bold()
                    .tint(.primaryText)
                }
            }
            .listRowBackground(Color.backgroundBox)
        }
        .background(Color.myBackground)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        
        .lockView()
    }
    
}

#Preview {
    CalculatorView()
        .environmentObject(SubscriptionStore())
        .environmentObject(NetworkMonitor())
}
