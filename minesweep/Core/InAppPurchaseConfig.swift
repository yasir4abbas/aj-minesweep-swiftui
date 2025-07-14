//
//  InAppPurchaseConfig.swift
//  minesweep
//
//  Created by yasir abbas on 09/07/2025.
//

import Foundation

struct InAppPurchaseConfig {
    static let productIDs = [
        "201": ProductInfo(
            id: "201",
            name: "Small Support",
            description: "Show your support with a small donation. Every bit helps keep the game free!",
            features: [
                "Support Game Development",
                "Keep the Game Free",
                "Help Add New Features",
                "Show Appreciation"
            ]
        ),
        "202": ProductInfo(
            id: "202", 
            name: "Big Support",
            description: "A larger donation to help support ongoing development and new features.",
            features: [
                "Major Development Support",
                "Priority Feature Requests",
                "Keep the Game Free",
                "Special Thanks"
            ]
        )
    ]
}

struct ProductInfo {
    let id: String
    let name: String
    let description: String
    let features: [String]
} 