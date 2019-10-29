//
//  CurrencyRate+Extensions.swift
//  Currency
//
//  Created by James Kong on 29/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

// MARK: Convenience initializers

extension CurrencyRate {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CurrencyRate.self, from: data) else { return nil }
        self = me
    }
}


extension CurrencyRate : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return currencyIso }
}

extension CurrencyRate : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "CurrencyRate"
    }
    
    static var primaryAttributeName: String {
        return "currencyIso"
    }
    
    init(entity: T) {
        currencyIso = entity.value(forKey: "currencyIso") as! String
        rate = entity.value(forKey: "rate") as! Double
        change = entity.value(forKey: "change") as! Double
        sellPrice = entity.value(forKey: "sellPrice") as! Double
        buyPrice = entity.value(forKey: "buyPrice") as! Double
    }
    
    func update(_ entity: T) {
        entity.setValue(currencyIso, forKey: "currencyIso")
        entity.setValue(rate, forKey: "rate")
        entity.setValue(change, forKey: "change")
        entity.setValue(sellPrice, forKey: "sellPrice")
        entity.setValue(buyPrice, forKey: "buyPrice")
        
//        removed auto save
//        do {
//            try entity.managedObjectContext?.save()
//        } catch let e {
//            print(e)
//        }
    }
    
}

