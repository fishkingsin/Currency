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
                brandLabel.text = "\(currencyIso): Forex"
            }
            if let change = currencyRate?.change {
                if change.isEqual(to: 0) {
                    changeLabel.textColor = UIColor.gray
                    changeLabel.text = "--"
                    changeIcon.text = ""
                } else {
                    if change > 0 {
                        changeIcon.textColor = UIColor.green
                        changeLabel.textColor = UIColor.green
                        changeIcon.text = "⋀"
                    } else {
                        changeIcon.textColor = UIColor.red
                        changeLabel.textColor = UIColor.red
                        changeIcon.text = "⋁"
                    }
                    
                    
                    changeLabel.text = "\(String(format:"%.3f", abs(change))) %"
                }
            } else {
                changeLabel.text = "--"
            }
            
            if let sellPrice = currencyRate?.sellPrice {
                if sellPrice.isEqual(to: 0) {
                    sellPriceLabel.text = "--"
                } else {
                    sellPriceLabel.text = String(format:"%.3f", sellPrice)
                }
            } else {
                sellPriceLabel.text = "--"
            }
            
            if let buyPrice = currencyRate?.buyPrice {
                if buyPrice.isEqual(to: 0) {
                    buyPriceLabel.text = "--"
                } else {
                    buyPriceLabel.text = String(format:"%.3f", buyPrice)
                }
            } else {
                buyPriceLabel.text = "--"
            }
        
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
        lbl.textColor = UIColor(named: "FontColor")
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let changeIcon : UILabel = {
           let lbl = UILabel()
           lbl.textColor = UIColor(named: "FontColor")
           lbl.font = UIFont.boldSystemFont(ofSize: 12)
           lbl.textAlignment = .left
           return lbl
       }()
    
    
    private let brandLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "SubFontColor")
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let changeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "FontColor")
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let sellPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "FontColor")
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let buyPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "FontColor")
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.backgroundColor = UIColor.clear
            addSubview(currencyIsoLabel)
            addSubview(changeIcon)
            addSubview(brandLabel)
            addSubview(changeLabel)
            addSubview(buyPriceLabel)
            addSubview(sellPriceLabel)
            
            let views: [String: Any] = [
                "superview": self,
                "currencyIsoLabel": currencyIsoLabel,
                "changeIcon": changeIcon,
                "brandLabel": brandLabel,
                "changeLabel": changeLabel,
                "sellPriceLabel": sellPriceLabel,
                "buyPriceLabel": buyPriceLabel,
            ]
            currencyIsoLabel.translatesAutoresizingMaskIntoConstraints = false
            changeIcon.translatesAutoresizingMaskIntoConstraints = false
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
                withVisualFormat: "H:|-leftMargin-[currencyIsoLabel(>=currentIosViewWidth)]-[changeIcon(8)]-8-[changeLabel(==currencyIsoLabel)]-8-[sellPriceLabel(==currencyIsoLabel)]-8-[buyPriceLabel(==currencyIsoLabel)]-rightMargin-|",
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
