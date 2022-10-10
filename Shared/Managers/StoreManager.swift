//
//  StoreManager.swift
//  VH Assistant
//
//  Created by Michael Craun on 10/9/22.
//

import Foundation
import StoreKit
import SwiftUI

import Combine

class StoreManager: NSObject, ObservableObject {
    @Published var isWorking: Bool = false
    @Published var error: Error?
    @Published var operation: String = ""
    
    private var identifiers: [String]
    private var productList: [SKProduct] = []
    private var purchaseIdentifier: String?
    private var product: SKProduct? {
        guard let purchaseIdentifier = purchaseIdentifier else { return nil }
        guard let product = productList.filter({ $0.productIdentifier == purchaseIdentifier }).first else { return nil }
        return product
    }
    
    init(identifiers: [String]) {
        self.identifiers = identifiers
        
        super.init()
        
        SKPaymentQueue.default().add(self)
        
        _ = $error.sink { error in
            if let error = error {
                FirebaseManager.report(error: error.localizedDescription)
            }
        }
        
        _ = $isWorking.sink(receiveValue: { isWorking in
            print("TAG: isWorking didUpdate:", isWorking)
        })
    }
    
    func purchaseProductWith(identifier: String) {
        self.purchaseIdentifier = identifier
        startProductRequest()
    }
    
    /// Used to ask user for rating after this method is called 10 times. It is recommended this method be called in viewDidLoad(_:)
    /// of your main UIViewController (otherwise it gets severely annoying to the user).
    static func askForRating() {
        guard let defaults = UserDefaults(suiteName: "StoreManager") else { return }
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let key = "timesAppOpened"
        let timesAppOpened = defaults.integer(forKey: key)
        
        print("TAG: timesAppOpened: \(timesAppOpened)")
        if timesAppOpened >= 10 {
            SKStoreReviewController.requestReview(in: scene)
            defaults.set(0, forKey: key)
        } else {
            defaults.set(timesAppOpened + 1, forKey: key)
        }
    }
}

extension StoreManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.isWorking = false
        self.productList = response.products
        
        print("TAG: response:", response.products.map({ $0.productIdentifier }))
        
        if !response.invalidProductIdentifiers.isEmpty {
            FirebaseManager.report(error: "Could not fetch products for \(response.invalidProductIdentifiers)")
        }
        
        if response.products.isEmpty {
            self.error = "Couldn't fetch any products..."
            return
        }
        
        if let purchaseIdentifier = purchaseIdentifier, SKPaymentQueue.canMakePayments() {
            purchaseProductWith(identifier: purchaseIdentifier)
        } else {
            self.error = "Your device is not set up to make payments."
        }
    }
    
    func requestDidFinish(_ request: SKRequest) {
        self.isWorking = false
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.isWorking = false
        self.error = error
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            queue.finishTransaction(transaction)
            
            switch transaction.transactionState {
            case .deferred:
                isWorking = false
                error = "Payment was deferred."
            case .purchased:
                isWorking = false
                error = "Payment succeeded. Thank you for your help!"
            case .purchasing:
                break
            case .restored:
                isWorking = false
                error = "Purchases have been restored. Thank you."
            default:
                isWorking = false
                error = "Payemnt failed.\n\(transaction.error?.localizedDescription ?? "An unknown error occured.")"
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return self.product == product
    }
    
    func startProductRequest() {
        guard let productIDs = NSSet(array: identifiers) as? Set<String> else { return }
        
        self.isWorking = true
        self.operation = "Fetching products..."
        
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
}
