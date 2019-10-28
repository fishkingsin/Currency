//
//  CurrencyCellViewModel.swift
//  Currency
//
//  Created by James Kong on 27/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class CurrencyCellViewModel {
    public enum Error {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let currentRate : PublishSubject<[CurrencyRate]> = PublishSubject()
    
    public let error : PublishSubject<Error> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData(){
        let stringURL = "https://www.freeforexapi.com/api/live"

        // simple case
        RxAlamofire.requestJSON(.get, stringURL)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (r, json) in
                print(json)
            }, onError: { (error) in
                
            }, onCompleted: {
                print("onCompleted")
            }) {
                print("disposed")
        }

//        self.loading.onNext(true)
//        APIManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil, completion: { (result) in
//            self.loading.onNext(false)
//            switch result {
//            case .success(let returnJson) :
//                let albums = returnJson["Albums"].arrayValue.compactMap {return Album(data: try! $0.rawData())}
//                let tracks = returnJson["Tracks"].arrayValue.compactMap {return Track(data: try! $0.rawData())}
//                self.albums.onNext(albums)
//                self.tracks.onNext(tracks)
//            case .failure(let failure) :
//                switch failure {
//                case .connectionError:
//                    self.error.onNext(.internetError("Check your Internet connection."))
//                case .authorizationError(let errorJson):
//                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
//                default:
//                    self.error.onNext(.serverMessage("Unknown Error"))
//                }
//            }
//        })
        
    }
    
    
}
