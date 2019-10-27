//
//  CurrencyCell.swift
//  Currency
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import UIKit


class CurrencyCell: UITableViewCell {
    var currencyRate: CurrencyRate? {
        didSet {
            currencyIsoLabel.text = currencyRate?.currencyIso
            if let currencyIso = currencyRate?.currencyIso {
                brandLabel.text = "\(currencyIso): Foprex"
            }
//            if let rate = currencyRate?.rate {
//                brandLabel.text = String(format:"%.3f", rate)
//            }
            changeLabel.text = "0.006"
            sellPriceLabel.text = "112.951"
            buyPriceLabel.text = "113.964"
        }
    }
    private enum Metrics {
        static let currentIosViewWidth: CGFloat = 30.0
        static let rightMargin:CGFloat = 20
        static let leftMargin:CGFloat = 20
    }
    let metrics = [
        "currentIosViewWidth": Metrics.currentIosViewWidth,
        "rightMargin": Metrics.rightMargin,
        "leftMargin": Metrics.leftMargin,
    ]
    
    
    private let currencyIsoLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let brandLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let changeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let sellPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let buyPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(currencyIsoLabel)
            addSubview(brandLabel)
            addSubview(changeLabel)
            addSubview(buyPriceLabel)
            addSubview(sellPriceLabel)
            
            let views: [String: Any] = [
                "superview": self,
                "currencyIsoLabel": currencyIsoLabel,
                "brandLabel": brandLabel,
                "changeLabel": changeLabel,
                "sellPriceLabel": sellPriceLabel,
                "buyPriceLabel": buyPriceLabel,
            ]
            currencyIsoLabel.translatesAutoresizingMaskIntoConstraints = false
            brandLabel.translatesAutoresizingMaskIntoConstraints = false
            changeLabel.translatesAutoresizingMaskIntoConstraints = false
            sellPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            buyPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            // 1
            var allConstraints: [NSLayoutConstraint] = []
            
            let alignCenterYConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:[superview]-(<=1)-[currencyIsoLabel]",
                
                metrics: nil,
                views: views)
            
            allConstraints += alignCenterYConstraints
            
            // 2
            let currencyIsoLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-leftMargin-[currencyIsoLabel(>=currentIosViewWidth)]-16-[changeLabel]-[sellPriceLabel]-[buyPriceLabel]-rightMargin-|",
                options: [.alignAllCenterY],
                metrics: metrics,
                views: views)
            allConstraints += currencyIsoLabelHorizontalConstraints
            
            let brandLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-20-[brandLabel(>=120)]",
                metrics: nil,
                views: views)
            allConstraints += brandLabelHorizontalConstraints
            
          
            
            // 3
            let iconVerticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-20-[currencyIsoLabel(18)]-3-[brandLabel(>=18)]-0-|",
                metrics: nil,
                views: views)
            allConstraints += iconVerticalConstraints
 
            // 7
            NSLayoutConstraint.activate(allConstraints)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
