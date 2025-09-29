//
//  PricePoint.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

struct PricePoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
