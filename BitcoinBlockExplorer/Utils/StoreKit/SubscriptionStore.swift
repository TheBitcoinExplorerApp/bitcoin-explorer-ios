//
//  SubscriptionStore.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 15/01/25.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState
typealias PurchaseResult = Product.PurchaseResult

enum StoreError: Error {
    case failedVerification
}

enum StoreAction {
    case successful
}

@MainActor
final class SubscriptionStore: ObservableObject {
    
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purschasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    @Published private(set) var action: StoreAction?
    
    private let productsId: [String] = ["VictorHugoPachecoAraujo.BitcoinBlockExplorer.monthly"]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        
        updateListenerTask = listenForTransactions()
        
        Task { [weak self] in
            
            guard let self else { return }
            
            await self.requestProducts()
            await self.updateCostumerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
}

extension SubscriptionStore {
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    
                    // Deliver products to the user
                    await self.updateCostumerProductStatus()
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func requestProducts() async {
        do {
            subscriptions = try await Product.products(for: productsId)
            print("subscriptions: \(subscriptions)")
        } catch {
            print("Failed product request from app store server: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            try await handlePurchase(from: result)
        } catch {
            print("Error in purchase: \(error)")
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        
        switch result {
        case .success(let verification):
            
            print("Purchase was success, now it's time to verify their purchase")
            // Check whether the transaction is verified.
            // If it isn't, this function rethrows the verification error.
            let transaction = try checkVerified(verification)
            
            action = .successful
            
            // The transaction is verified. Deliver content to the user.
            await updateCostumerProductStatus()
            
            // Always finish a transaction
            await transaction.finish()
            
        case .pending:
            print("The user needs to complete something")
            
        case .userCancelled:
            print("The user cancelled the purchase before the transaction started")
            
        default:
            break
        }
    }
    
    func reset() {
        action = nil
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("User verification failed")
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func updateCostumerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: {$0.id == transaction.productID}) {
                        purschasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
                
                // Always finish a transaction
                await transaction.finish()
                
            } catch {
                print("Failed updating products")
            }
        }
    }
    
}
