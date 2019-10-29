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
    
    static func parseObject(dictionary: [String : AnyObject]) -> Result<CurrencyRate, Error> {
        print("dic \(dictionary)")
        let rates = dictionary["rates"] as? [String: Any]
        
        if let keys = rates?.keys {
            if let key = keys.first {
                let rateObject = rates![key] as? [String: Any]
                print("rates[key] \(String(describing: rateObject![key]))")
                let rate = rateObject?["rate"] as! Double
                let currencyRate = CurrencyRate(currencyIso: key , rate: rate, change: 0, sellPrice: rate * 0.9, buyPrice: rate * 1.1)
                return .success(currencyRate)
                
            }
        }
        return .failure(NSError(domain: "currencyRate", code: 0, userInfo: nil))
    }
    
}
