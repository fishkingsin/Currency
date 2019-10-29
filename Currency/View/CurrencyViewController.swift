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
    var currencyRates:[CurrencyRate] = [CurrencyRate]()
    
    public var currencyRatesPublishSubject = PublishSubject<[CurrencyRate]>()
    public var interval = PublishSubject<Int>()
    
    lazy var viewModel : CurrencyViewModel = {
        let viewModel = CurrencyViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.delegate = self
        
        
        setupBinding()
        self.viewModel.requestData()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Header.instanceFromNib()
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 90)
        header.bounds = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 90)
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.viewModel.cancelRequest()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.viewModel.resumeInterval()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private func setupBinding(){
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        
        self.currencyRatesPublishSubject.bind(to: self.tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) {  (row, currencyRate, cell) in
            cell.currencyRate = currencyRate
        }.disposed(by: disposeBag)
        
        viewModel
        .currencyRatesPublishSubject
        .observeOn(MainScheduler.instance)
            .bind(to: self.currencyRatesPublishSubject)
        .disposed(by: disposeBag)
        
        viewModel
        .interval
        .observeOn(MainScheduler.instance)
            .bind(to: self.interval)
        .disposed(by: disposeBag)
        
        
        self.currencyRatesPublishSubject.subscribe{ (event) in
            
            let pair:[String] = (event.element?.compactMap({ currencyRate -> String in
                return currencyRate.currencyIso
            }))!

            let range = NSMakeRange(self.tableView.indexPathsForVisibleRows!.startIndex, self.tableView.indexPathsForVisibleRows!.count)
            let p = self.subArray(array: pair, range: range)
            print("\(p)")
//            self.viewModel.requestDatas(params: p)
            
        
        }.disposed(by: disposeBag)
    }
    
    func subArray<T>(array: [T], range: NSRange) -> [T] {
      if range.location > array.count {
        return []
      }
      return Array(array[range.location..<min(range.length, array.count)])
    }
}
