//
//  CurrencyRate.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
struct CurrencyRate:Codable {
    
    let currencyIso : String
    let rate : Double
    let change: Double
    let sellPrice: Double
    let buyPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case currencyIso
        case rate
        case change
        case sellPrice
        case buyPrice
    }
}


// MARK: Convenience initializers

extension CurrencyRate {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CurrencyRate.self, from: data) else { return nil }
        self = me
    }
}
