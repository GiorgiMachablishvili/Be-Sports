import StoreKit
import Foundation

final class PremiumManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = PremiumManager()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts { _ in }
    }
    
    func start() {
        fetchProducts { _ in }
    }
    
    func buyMonthly(completion: @escaping (Bool) -> Void) {
        guard didFetchProducts else {
            fetchProducts { [weak self] success in
                guard
                    success,
                    let self = self,
                    let product = self.monthlyProduct
                else {
                    completion(false)
                    return
                }
                self.purchase(product: product, completion: completion)
            }
            return
        }
        guard let product = monthlyProduct else {
            completion(false)
            return
        }
        purchase(product: product, completion: completion)
    }
    
    func buyYearly(completion: @escaping (Bool) -> Void) {
        guard didFetchProducts else {
            fetchProducts { [weak self] success in
                guard
                    success,
                    let self = self,
                    let product = self.yearlyProduct
                else {
                    completion(false)
                    return
                }
                self.purchase(product: product, completion: completion)
            }
            return
        }
        guard let product = yearlyProduct else {
            completion(false)
            return
        }
        purchase(product: product, completion: completion)
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        guard didFetchProducts else {
            fetchProducts { [weak self] success in
                guard let self = self else {
                    completion(false)
                    return
                }
                self.restoreFlow = completion
                SKPaymentQueue.default().restoreCompletedTransactions()
            }
            return
        }
        restoreFlow = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private var monthlyProduct: SKProduct?
    private var yearlyProduct: SKProduct?
    private var allProducts: [SKProduct] = []
    
    private var productRequest: SKProductsRequest?
    private var didFetchProducts = false
    private let productIDs: Set<String> = ["premium_monthly", "premium_yearly"]
    
    private var currentPurchaseFlow: ((Bool) -> Void)?
    private var restoreFlow: ((Bool) -> Void)?
    private var fetchCompletion: ((Bool) -> Void)?
    
    private func fetchProducts(completion: @escaping (Bool) -> Void) {
        if productRequest != nil {
            completion(false)
            return
        }
        let request = SKProductsRequest(productIdentifiers: productIDs)
        productRequest = request
        request.delegate = self
        request.start()
        fetchCompletion = completion
    }
    
    private func purchase(product: SKProduct, completion: @escaping (Bool) -> Void) {
        currentPurchaseFlow = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        didFetchProducts = true
        productRequest = nil
        allProducts = response.products
        for product in response.products {
            if product.productIdentifier == "premium_monthly" {
                monthlyProduct = product
            } else if product.productIdentifier == "premium_yearly" {
                yearlyProduct = product
            }
        }
        fetchCompletion?(true)
        fetchCompletion = nil
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        productRequest = nil
        didFetchProducts = false
        fetchCompletion?(false)
        fetchCompletion = nil
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var premiumUnlocked = false
        
        for txn in transactions {
            switch txn.transactionState {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(txn)
                premiumUnlocked = true
            case .failed:
                SKPaymentQueue.default().finishTransaction(txn)
                currentPurchaseFlow?(false)
                currentPurchaseFlow = nil
            case .purchasing, .deferred:
                break
            @unknown default:
                break
            }
        }
        
        if premiumUnlocked {
            UserDefaults.standard.setValue(true, forKey: "isPremium")
            currentPurchaseFlow?(true)
            restoreFlow?(true)
            currentPurchaseFlow = nil
            restoreFlow = nil
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        restoreFlow?(true)
        restoreFlow = nil
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        restoreFlow?(false)
        restoreFlow = nil
    }
}
