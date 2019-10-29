//
//  CurrencyViewController.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CurrencyViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    let cellId = "CurrencyCell"
    
    public var currencyRatesPublishSubject = PublishSubject<[CurrencyRate]>()
    
    lazy var viewModel : CurrencyViewModel = {
        let viewModel = CurrencyViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.delegate = self
        viewModel
        .currencyRatesPublishSubject
        .observeOn(MainScheduler.instance)
            .bind(to: self.currencyRatesPublishSubject)
        .disposed(by: disposeBag)
        
        setupBinding()
        self.viewModel.requestData()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Header.instanceFromNib()
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    private func setupBinding(){
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        self.currencyRatesPublishSubject.bind(to: self.tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) {  (row, currencyRate, cell) in
            cell.currencyRate = currencyRate
            }.disposed(by: disposeBag)
        self.currencyRatesPublishSubject.subscribe { (currencyRates) in
//            print("setupBinding \(currencyRates)")
        }
    }
}
