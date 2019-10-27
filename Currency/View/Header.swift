//
//  Header.swift
//  Currency
//
//  Created by James Kong on 26/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import UIKit
class Header: UIView {
    
    private enum Metrics {
        static let row1Width: CGFloat = 30.0
        static let rightMargin:CGFloat = 20
        static let leftMargin:CGFloat = 20
    }
    let metrics = [
        "row1Width": Metrics.row1Width,
        "rightMargin": Metrics.rightMargin,
        "leftMargin": Metrics.leftMargin,
    ]
    
    
    private let row1 : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let row2 : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let row3 : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let row4 : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let row5 : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(row1)
        addSubview(row2)
        addSubview(row3)
        addSubview(row4)
        addSubview(row5)
        
        let views: [String: Any] = [
            "superview": self,
            "row1": row1,
            "row2": row2,
            "row3": row3,
            "row4": row4,
            "row5": row5,
        ]
        row1.translatesAutoresizingMaskIntoConstraints = false
        row2.translatesAutoresizingMaskIntoConstraints = false
        row3.translatesAutoresizingMaskIntoConstraints = false
        row4.translatesAutoresizingMaskIntoConstraints = false
        row5.translatesAutoresizingMaskIntoConstraints = false
        // 1
        var allConstraints: [NSLayoutConstraint] = []
        
        let alignCenterYConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[superview]-(<=1)-[row1]",
            
            metrics: nil,
            views: views)
        
        allConstraints += alignCenterYConstraints
        
        // 2
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-leftMargin-[row1(>=row1Width)]-16-[row2]-[row3]-[row4]-rightMargin-|",
            options: [.alignAllCenterY],
            metrics: metrics,
            views: views)
        allConstraints += topRowHorizontalConstraints
        
        let brandLabelHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[row5(>=120)]",
            metrics: nil,
            views: views)
        allConstraints += brandLabelHorizontalConstraints
        
        
        
        // 3
//        let verticalConstraints = NSLayoutConstraint.constraints(
//            withVisualFormat: "V:|-20-[row1(18)]-3-[row5(>=18)]-0-|",
//            metrics: nil,
//            views: views)
//        allConstraints += verticalConstraints
        
        // 7
        NSLayoutConstraint.activate(allConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
