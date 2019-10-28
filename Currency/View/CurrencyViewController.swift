//
//  CurrencyViewController.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import UIKit
class CurrencyViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = CurrencyDataSource()
    let cellId = "CurrencyCell"
    
    lazy var viewModel : CurrencyViewModel = {
        let viewModel = CurrencyViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor( named:"CustomControlColor")
        self.tableView.backgroundColor = UIColor( named:"CustomControlColor")
        //self.title = "£ Exchange rate"
        
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = 60.0
        
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.tableView.reloadData()
        }
        
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
}
