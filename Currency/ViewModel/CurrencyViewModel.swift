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
    var indexPathsForVisibleRows: [NSIndexPath]?
    
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
        case errorMessage(String)
    }
    public let currencyRatesPublishSubject : PublishSubject<[CurrencyRate]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let interval: PublishSubject<Int> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    lazy var currencyRates : [[String: CurrencyRate]] = {
        let currencyRates = [[String: CurrencyRate]]()
        return currencyRates
    }()
    
    init () {
        self.resumeInterval()
    }
    
    public func requestData(){
        
        self.loading.onNext(true)
        RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live")
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {(r, data) in
                    let dict = data as? [String: AnyObject]
                    let pairs = dict?["supportedPairs"] as! Array<String>
                    self.requestDatas(params: pairs)
                    let currencyRates = pairs.compactMap {return CurrencyRate(currencyIso: $0, rate: 0, change: 0, sellPrice: 0, buyPrice: 0)}
                    self.currencyRatesPublishSubject.onNext(currencyRates)
            },
                       onError: { (err) in
                        self.error.onNext(.internetError("unable to fetch data"))
            },
                       onCompleted: {
                        self.loading.onNext(false)
                
                
            }) {
                print("dispose")
        }.disposed(by: disposeBag)
        
    }
    
    public func requestDatas(params: [String]){
        
        let collections = params.compactMap { RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\($0)")}
        Observable.zip(collections)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (responses) in
                
                let currencyRates = responses.compactMap({ (arg0) -> CurrencyRate? in
                    let (_, json) = arg0
                    let result = Converter.parseObject(dictionary: json as! [String: AnyObject])
                    switch(result) {
                    case .success(let currencyRate):
                        return currencyRate
                    case .failure( _):
                        return nil
                    }
                })
                self.currencyRatesPublishSubject.onNext(currencyRates)
            }, onError: { (error) in
                self.error.onNext(.internetError("unable to fetch data"))
            }, onCompleted: {
                self.loading.onNext(false)
            }) {
                print("dispose")
            }
            .disposed(by: disposeBag)
    }
    
    public mutating func cancelRequest () {
        self.disposeBag = DisposeBag()
    }
    
    public func resumeInterval() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        Observable<Int>.interval(.seconds(10), scheduler: scheduler)
        .debug("interval")
            .subscribe({ (event) in
                print(event)
            })
        .disposed(by: disposeBag)
    }
}
