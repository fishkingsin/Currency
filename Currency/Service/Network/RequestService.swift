//
//  RequestService.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

final class RequestService {
    
    // todo add model
    func loadData(urlString: String, session: URLSession = URLSession(configuration: .default), completion: @escaping (Result<Data, ErrorResult>) -> Void) -> RxSwift.Observable? {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        
//        var request = RequestFactory.request(method: .GET, url: url)
//
//        if let reachability = Reachability(), !reachability.isReachable {
//            request.cachePolicy = .returnCacheDataDontLoad
//        }
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
//                return
//            }
//
//            if let data = data {
//                completion(.success(data))
//            }
//        }
//        task.resume()
        // MARK: URLSession simple and fast
       let manager = SessionManager.default

       let task = manager.rx.json(.get, urlString)
           .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (Any) in
            
        }, onError: { (Error) in
            
        }, onCompleted: {
            
        }) {
            
        }
//        .subscribe(onNext: { data in
//            completion(.success(data))
//        }, onError: { error in
//            completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
//        }, onCompleted: {
//
//        }) {
//
//        }
        return task
    }
}
