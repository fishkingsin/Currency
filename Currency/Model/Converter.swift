//
//  Converter.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import RxSwift
struct Converter {

    let base : String
    let date : String

    let rates : [CurrencyRate]
}

extension Converter {
    
    static func parseObject(dictionary: [String : AnyObject], previous: [CurrencyRate]) -> Result<CurrencyRate, Error> {
        print("dic \(dictionary)")
        let rates = dictionary["rates"] as? [String: Any]
        
        if let keys = rates?.keys {
            if let key = keys.first {
                let rateObject = rates![key] as? [String: Any]
                // mock new rate changed
                let rate = rateObject?["rate"] as! Double * Double.random(in: 0.9 ..< 1.1)
                
                let prev = previous.filter { $0.currencyIso == key }
                if (prev.count == 0) {
                    let currencyRate = CurrencyRate(currencyIso: key , rate: rate, change: 0 , sellPrice: rate * Double.random(in: 0.9 ..< 0.9999), buyPrice: rate * Double.random(in: 1.000001 ..< 1.1))
                    return .success(currencyRate)
                } else {
                    let change = prev.first!.rate == 0 ? 0 : (prev.first!.rate - rate) / prev.first!.rate
                    let currencyRate = CurrencyRate(currencyIso: key , rate: prev.first!.rate == 0 ? rate : prev.first!.rate, change: change , sellPrice: rate * Double.random(in: 0.9 ..< 0.9999), buyPrice: rate * Double.random(in: 1.000001 ..< 1.1))
                    return .success(currencyRate)
                }
                
            }
        }
        return .failure(NSError(domain: "CurrencyRate", code: 0, userInfo: []))
    }
    
}
