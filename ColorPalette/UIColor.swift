//
//  UIColor.swift
//  ColorPalette
//
//  Created by Gagandeep Singh on 21/4/19.
//  Copyright © 2019 Gagandeep Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
    
    convenience init(netHex: Int) {
        self.init(r: (netHex >> 16) & 0xff, g: (netHex >> 8) & 0xff, b: netHex & 0xff)
    }
    
    convenience init(gray: Int) {
        self.init(r: gray, g: gray, b: gray)
    }
}
