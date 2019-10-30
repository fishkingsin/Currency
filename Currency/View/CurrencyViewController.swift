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
import CoreData

class CurrencyViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var equityLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    private let disposeBag = DisposeBag()
    let cellId = "CurrencyCell"
    
    var currencyRates:[CurrencyRate] = [CurrencyRate]()
    
    public var currencyRatesPublishSubject = PublishSubject<[CurrencyRate]>()
    public var interval = PublishSubject<Int>()
    public var loading = PublishSubject<Bool>()
    
    lazy var viewModel : CurrencyViewModel = {
        let viewModel = CurrencyViewModel()
        return viewModel
    }()
    
    var indicator = UIActivityIndicatorView()
    
    var managedObjectContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor(named: "SubFontColor")
        
        self.tableView.delegate = self
        self.managedObjectContext = shareLazyCoreDataUtils.managedObjectContext
        setupBinding()
        self.activityIndicator()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.viewModel.resumeInterval()
        if let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows {
            if indexPathsForVisibleRows.count > 0 {
                let range = NSMakeRange(indexPathsForVisibleRows.first!.row,
                                        indexPathsForVisibleRows.last!.row + 1)
                self.viewModel.updateData(range: range)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private func setupBinding(){
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        
        self.currencyRatesPublishSubject.bind(to: self.tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) {  (row, currencyRate, cell) in
            cell.currencyRate = currencyRate
        }.disposed(by: disposeBag)
        
        self.managedObjectContext.rx.entities(CurrencyRate.self, predicate: nil, sortDescriptors: nil)
            .subscribe(onNext: { currencyRates in
                if (currencyRates.count == 0) {
                    self.viewModel.requestData()
                }
                //            self.equityLabel.text = "$\(10000 * currencyRates.count)"
                // hardcode
                self.balanceLabel.text = "$\(10000 * currencyRates.count)"
                let sellPrices = currencyRates.compactMap{ currencyRate -> Double in
                    let sellPrice = currencyRate.sellPrice
                    // hardcode
                    let equity = 10000 * currencyRate.rate / sellPrice
                    return equity
                }.reduce(0, +)
                self.equityLabel.text = "$\(String(format: "%.2f", sellPrices))"
            }).disposed(by: disposeBag)
        
        viewModel
            .interval
            .observeOn(MainScheduler.instance)
            .bind(to: self.interval)
            .disposed(by: disposeBag)
        
        self.managedObjectContext.rx.entities(CurrencyRate.self, predicate: nil, sortDescriptors: nil)
            .bind(to: self.currencyRatesPublishSubject)
            .disposed(by: disposeBag)
        
        
        viewModel
            .loading
            .observeOn(MainScheduler.instance)
            .bind(to: self.loading)
            .disposed(by: disposeBag)
        
        self
            .loading
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                if (event.element!) {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        
        
        viewModel.interval
            .observeOn(MainScheduler.instance)
            .subscribe { _ in
                if let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows {
//                    print("indexPathsForVisibleRows \(indexPathsForVisibleRows)")
                    if indexPathsForVisibleRows.count > 0 {
                        let range = NSMakeRange(indexPathsForVisibleRows.first!.row,
                                                indexPathsForVisibleRows.last!.row + 1)
//                        print("range \(range)")
                        self.viewModel.updateData(range: range)
                    }
                }
        }
    }
    
}
