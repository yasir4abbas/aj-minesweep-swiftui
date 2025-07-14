//
//  PurchaseManager.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    @Published var hasSupported = false
    
    private let storeKitManager = StoreKitManager()
    
    init() {
        Task {
            await updatePurchaseStatus()
        }
    }
    
    func updatePurchaseStatus() async {
        await storeKitManager.updatePurchasedProducts()
        hasSupported = storeKitManager.isPurchased("201") || storeKitManager.isPurchased("202")
    }
    
    func getStoreKitManager() -> StoreKitManager {
        return storeKitManager
    }
} 