//
//  Header.swift
//  Currency
//
//  Created by James Kong on 29/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import Foundation
import UIKit
class Header : UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Header", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
