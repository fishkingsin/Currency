//
//  RXRequestService.swift
//  Currency
//
//  Created by James Kong on 26/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation


import Foundation
import RxAlamofire
import RxSwift
import Reachability
final class RxRequestService {
    
    // todo add model
    func loadData(urlString: String, completion: @escaping (Result<Data, ErrorResult>) -> Void) -> Disposable? {
        return RxAlamofire.requestJSON(.get, urlString)
        .subscribe(onNext: { (r, json) in
            if let dict = json as? [String: AnyObject] {
                let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                if let conversionRate = valDict["USD"] as? Float {
                    print(conversionRate)
//                    self?.toTextField.text = formatter
//                        .string(from: NSNumber(value: conversionRate * fromValue))
                }
            }
            }, onError: { (error) in
                print(error)
        })
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.network(string: "Wrong url format")))
//            return nil
//        }
//
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
//        return task
    }
}
