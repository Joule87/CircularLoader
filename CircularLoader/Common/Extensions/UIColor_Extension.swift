//
//  UIColor_Extension.swift
//  CircularLoader
//
//  Created by Julio Collado on 1/4/20.
//  Copyright © 2020 Julio Collado. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(displayP3Red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rbg(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rbg(r: 234, g: 46, b: 33)
    static let trackStrokeColor = UIColor.rbg(r: 56, g: 26, b: 49)
    static let pulsatingFillColor = UIColor.rbg(r: 86, g: 30, b: 63)
}
