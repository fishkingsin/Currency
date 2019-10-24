//
//  Converter.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
struct Converter {

    let base : String
    let date : String

    let rates : [CurrencyRate]
}

extension Converter : Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Result<Converter, ErrorResult> {
        if let base = dictionary["base"] as? String,
            let date = dictionary["date"] as? String,
            let rates = dictionary["rates"] as? [String: Double] {
            
            let finalRates : [CurrencyRate] = rates.flatMap({ CurrencyRate(currencyIso: $0.key, rate: $0.value) })
            let conversion = Converter(base: base, date: date, rates: finalRates)
            
            return Result.success(conversion)
        } else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse conversion rate"))
        }
    }
}
