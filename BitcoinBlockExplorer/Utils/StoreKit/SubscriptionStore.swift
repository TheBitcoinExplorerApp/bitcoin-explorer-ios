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
typealias TransactionListener = Task<Void, Error>

enum StoreError: LocalizedError {
    case failedVerification
    case system(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "User transaction verification failed"
        case .system(let err):
            return err.localizedDescription
        }
    }
}

enum StoreAction: Equatable {
    case successful
    case failed(StoreError)
    
    static func == (lhs: StoreAction, rhs: StoreAction) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case (.failed(let lhsErr), .failed(let rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        default:
            return false
        }
    }
}

@MainActor
final class SubscriptionStore: ObservableObject {
    
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purschasedSubscriptions: Bool = false
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    @Published private(set) var action: StoreAction? {
        didSet {
            switch action {
            case .failed:
                hasError = true
            default:
                hasError = false
            }
        }
    }
    
    
    @Published var hasError: Bool = false
    
    var error: StoreError? {
        switch action {
        case .failed(let err):
            return err
        default:
            return nil 
        }
    }
    
    private let productsId: [String] = ["VictorHugoPachecoAraujo.BitcoinBlockExplorer.monthly"]
    
    private var updateListenerTask: TransactionListener? = nil
    
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
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            try await handlePurchase(from: result)
        } catch {
            action = .failed(.system(error))
            print("Error in purchase: \(error)")
            
        }
    }

    func reset() {
        action = nil
    }
    
}

private extension SubscriptionStore {
    
    func listenForTransactions() -> TransactionListener {
        return Task.detached(priority: .background) { @MainActor [weak self] in
            
            guard let self else { return }
            
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    self.action = .successful
                    
                    // Deliver products to the user
                    await self.updateCostumerProductStatus()
                    
                    await transaction.finish()
                } catch {
                    self.action = .failed(.system(error))
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
            action = .failed(.system(error))
            print("Failed product request from app store server: \(error)")
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
                        purschasedSubscriptions = true
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
