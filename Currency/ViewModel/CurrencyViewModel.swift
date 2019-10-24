//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
struct CurrencyViewModel {

    weak var dataSource : GenericDataSource<CurrencyRate>?

    init(dataSource : GenericDataSource<CurrencyRate>?) {
        self.dataSource = dataSource
    }

    func fetchCurrencies() {
        CurrencyService.shared.fetchConverter { result in

            DispatchQueue.main.async {
                switch result {
                case .success(let converter) :
                    // reload data
                    self.dataSource?.data.value = converter.rates

                    break
                case .failure(let error) :
                    print("Parser error \(error)")
                    break
                }
            }
        }
    }
}
