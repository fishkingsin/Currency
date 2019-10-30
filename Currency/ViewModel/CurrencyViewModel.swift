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
import RxCoreData
import CoreData

class CurrencyViewModel {
    let managedObjectContext: NSManagedObjectContext!
    var disposeBag: DisposeBag = DisposeBag()
    var intervalDisposable: Disposable!
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
        self.managedObjectContext = shareLazyCoreDataUtils.managedObjectContext
        self.resumeInterval()
        
    }
    
    public func requestData(){
        
        self.loading.onNext(true)
        RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live")
            //            .debug("requestData")
            .observeOn(MainScheduler.instance)
            
            .flatMap({ (r, data) -> Observable<[(HTTPURLResponse, Any)]> in
                let dict = data as? [String: AnyObject]
                let pairs = dict?["supportedPairs"] as! Array<String>
                let collection = pairs.compactMap { RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\($0)")}
                return Observable.zip(collection)
            })
            .take(1)
            .subscribe(
                onNext: {responses in
                    let currencyRates = responses.compactMap({ (arg0) -> CurrencyRate? in
                        let (_, json) = arg0
                        let result = Converter.parseObject(dictionary: json as! [String: AnyObject], previous: [])
                        switch(result) {
                        case .success(let currencyRate):
                            return currencyRate
                            break
                        case .failure(_):
                            return nil
                            break
                        }
                    })
                    for currencyRate in currencyRates {
                        do {
                            _ = try? self.managedObjectContext.rx.update(currencyRate)
                            
                        } catch let e {
                            print(e)
                        }
                    }
                    do {
                        try self.managedObjectContext?.save()
                    } catch let e {
                        print(e)
                    }
                    //                    let dict = data as? [String: AnyObject]
                    //                    let pairs = dict?["supportedPairs"] as! Array<String>
                    //                    self.requestDatas(params: pairs)
                    //
                    //
                    //                    let currencyRates = pairs.filter{$0.contains("USD")}.compactMap {
                    //                        return CurrencyRate(currencyIso: $0, rate: 0, change: 0, sellPrice: 0, buyPrice: 0)
                    //                    }
                    //                    self.currencyRatesPublishSubject.onNext(currencyRates)
                    //                    for currencyRate in currencyRates {
                    //                        _ = try? self.managedObjectContext.rx.update(currencyRate)
                    //                    }
                    //                    // save
                    //                    do {
                    //                        try self.managedObjectContext?.save()
                    //                    } catch let e {
                    //                        print(e)
                    //                    }
                    
                    
            },
                onError: { (err) in
                    self.error.onNext(.internetError("unable to fetch data"))
            },
                onCompleted: {
                    self.loading.onNext(false)
                    
                    
            }) {
                //                print("dispose")
        }.disposed(by: disposeBag)
        
    }
    
    public func requestDatas(params: [String]){
        let collections = params.compactMap { RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\($0)")}
        
        Observable.combineLatest(
            Observable.zip(collections),
            self.managedObjectContext.rx.entities(CurrencyRate.self, predicate: NSPredicate(format: "self.currencyIso in %@", params), sortDescriptors: nil))
            .observeOn(MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { (responses, preCurrencyRates) in
                
                let currencyRates = responses.compactMap({ (arg0) -> CurrencyRate? in
                    let (urlResponse, json) = arg0
                    
                    let result = Converter.parseObject(dictionary: json as! [String: AnyObject], previous: preCurrencyRates)
                    switch(result) {
                    case .success(let currencyRate):
                        return currencyRate
                    case .failure( _):
                        if let key = urlResponse.url?.query?.split(separator: "=").last! {
                            let currencyRate = CurrencyRate(currencyIso: String(key), rate: 0, change: 0, sellPrice: 0, buyPrice: 0)
                            do {
                                try? self.managedObjectContext.rx.delete(currencyRate)
                            } catch {
                                print(error)
                            }
                        }
                        return nil
                    }
                })
                for currencyRate in currencyRates {
                    _ = try? self.managedObjectContext.rx.update(currencyRate)
                }
                // save
                do {
                    try self.managedObjectContext?.save()
                } catch let e {
                    print(e)
                }
                
            }, onError: { (error) in
                self.error.onNext(.internetError("unable to fetch data"))
            }, onCompleted: {
                self.loading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    public func cancelRequest () {
        self.disposeBag = DisposeBag()
    }
    
    public func resumeInterval() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        self.intervalDisposable?.dispose()
        self.intervalDisposable = Observable<Int>.interval(.seconds(5), scheduler: scheduler)
            .observeOn(MainScheduler.instance)
            //        .debug("interval")
            .subscribe({ event in
                self.interval.on(event)
                //                self.interval.on(event)
            })
    }
    
    public func updateData(range: NSRange) {
        
        self.managedObjectContext.rx.entities(CurrencyRate.self, predicate: nil, sortDescriptors: nil)
            .take(1)
            .map { currencyRates -> [String] in
                let array1 = self.subArray(array: currencyRates, range: range).compactMap({ c -> String in
                    return c.currencyIso
                })
                //                print("array1 \(array1)")
                return array1
        }.subscribe(onNext: { params in
            self.requestDatas(params: params)
        }, onError: { error in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
        
    }
    
    func subArray<T>(array: [T], range: NSRange) -> [T] {
        if range.location > array.count {
            return []
        }
        return Array(array[range.location..<min(range.length, array.count)])
    }
}
