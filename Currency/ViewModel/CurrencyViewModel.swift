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
    weak var dataSource : GenericDataSource<CurrencyRate>?

    
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
    
    init(service: CurrencyServiceProtocol = FileDataService.shared, dataSource : GenericDataSource<CurrencyRate>?) {
        self.dataSource = dataSource
//        self.service = service
    }
    public func requestData(){
        
        self.loading.onNext(true)
        APIManager.requestData(url: "", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                 do {
                    
//                    if let currencyRate = try CurrencyRate(data: returnJson["supportedPairs"].rawData()) {
//                        self.currencyRate.onNext(currencyRate)
//                    }
                 } catch _ {
                    self.error.onNext(.errorMessage("failed to parse"))
                }
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        
    }
    
    public func requestDatas(params: [String]){
        RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live")
        .observeOn(MainScheduler.instance)
            .flatMap { (arg) -> Observable<(HTTPURLResponse, Any)> in
                let (res, data) = arg
//                print(data)
                
                let dict = data as? [String: AnyObject]
                let pairs = dict?["supportedPairs"] as! Array<String>
                let collections = pairs.compactMap{return RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\($0)")}
//                var collections = Array<Observable<(HTTPURLResponse, Any)>>()
//                for pair in pairs {
//                    let observable:Observable = RxAlamofire.requestJSON(.get, "https://www.freeforexapi.com/api/live?pairs=\(pair)")
//                    collections.append(observable)
//                }
                return Observable.merge(collections)
                
                
        }.map({ (r, json) in
            
            if let returnJson = json as? [String: AnyObject] {
                let currenyRate= returnJson["rates"].flatMap{return CurrencyRate(data: try! $0.rawData())}
                print(currenyRate)
            }
                
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
