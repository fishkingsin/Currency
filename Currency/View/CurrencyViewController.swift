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
    
    public var currencyRates = PublishSubject<[CurrencyRate]>()
    
    lazy var viewModel : CurrencyViewModel = {
        let viewModel = CurrencyViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.backgroundColor = UIColor( named:"CustomControlColor")
        //self.title = "£ Exchange rate"
        
//        self.tableView.dataSource = self.dataSource
//        self.tableView.delegate = self
//        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 60.0
//        self.tableView.rowHeight = 60.0
        
//        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
//            self?.tableView.reloadData()
//        }
        
        viewModel
        .currencyRates
        .observeOn(MainScheduler.instance)
            .bind(to: self.currencyRates)
        .disposed(by: disposeBag)
        
        setupBinding()
        self.viewModel.requestData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Header(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 59))
        
        return header
    }
    
    private func setupBinding(){
        
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        
        self.currencyRates.bind(to: self.tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) {  (row, currencyRate, cell) in
            cell.currencyRate = currencyRate
            }.disposed(by: disposeBag)
        
//        self.tableView.rx.willDisplayCell
//            .subscribe(onNext: ({ (cell,indexPath) in
//                cell.alpha = 0
//                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
//                cell.layer.transform = transform
//                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                    cell.alpha = 1
//                    cell.layer.transform = CATransform3DIdentity
//                }, completion: nil)
//            })).disposed(by: disposeBag)
    }
}
