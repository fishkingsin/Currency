//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper
import SwiftyJSON


struct CurrencyViewModel {

    var disposeBag: DisposeBag = DisposeBag()

    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
        case errorMessage(String)
    }
//    public let currencyRate : PublishSubject<CurrencyRate> = PublishSubject()
    public let currencyRates : PublishSubject<[CurrencyRate]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    init() {
        
//        self.service = service
    }
    public func requestData(){
        
        self.loading.onNext(true)
        RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (r, data) in
                let dict = data as? [String: AnyObject]
                let pairs = dict?["supportedPairs"] as! Array<String>
                let currencyRates = pairs.compactMap {return CurrencyRate(currencyIso: $0, rate: 0, change: 0, sellPrice: 0, buyPrice: 0)}
                self.currencyRates.onNext(currencyRates)
            }, onError: { (err) in
                self.error.onNext(.internetError("unable to fetch data"))
            }, onCompleted: {
                self.loading.onNext(false)
            }) {
                print("dispose")
        }.disposed(by: disposeBag)
        
    }
    
    public func requestDatas(params: [String]){
        RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live")
        .observeOn(MainScheduler.instance)
            .flatMap { (arg) -> Observable<(HTTPURLResponse, Any)> in
                let (res, data) = arg
//                print(data)
                
                let dict = data as? [String: AnyObject]
                let pairs = dict?["supportedPairs"] as! Array<String>
                let currencyRates = pairs.compactMap {return CurrencyRate(currencyIso: $0, rate: 0, change: 0, sellPrice: 0, buyPrice: 0)}
                self.currencyRates.onNext(currencyRates)
                let collections = pairs.compactMap { (pair) -> Observable<(HTTPURLResponse, Any)> in
                    print("pair \(pair)")
                    return RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\(pair)")
                }
//                var collections = Array<Observable<(HTTPURLResponse, Any)>>()
//                for pair in pairs {
//                    let observable:Observable = RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\(pair)")
//                    collections.append(observable)
//                }
                return Observable.merge(collections)
                
                
        }.map({ (r, json) -> Any in
            
            if let dic = json as? [String: AnyObject]{
                print("dic \(dic)")
                let rates = dic["rates"] as? [String: AnyObject]
                if let keys = rates?.keys {
                    let key = keys.first
                    let currencyRate = CurrencyRate(currencyIso: key ?? "" , rate: 0, change: 0, sellPrice: 0, buyPrice: 0)
                    return currencyRate
                }
            }
            return NSError.init(domain: "com.something", code: 0, userInfo: nil)
                
        })
        .enumerated()
            
        .observeOn(MainScheduler.instance)

        .subscribe(onNext: { (res, data) in
            print(data)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("complete")
        })
            .disposed(by: disposeBag)
    }
}
