//
//  Extension.swift
//  FeedPet
//
//  Created by HwangGisu on 2017. 12. 27..
//  Copyright © 2017년 HwangGisu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    // HEX color를 변환하기 위한 확장 코드
    // 출처:https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIView {
    
    func autoLayoutAnchor(top:NSLayoutYAxisAnchor?,
                          left:NSLayoutXAxisAnchor?,
                          right:NSLayoutXAxisAnchor?,
                          bottom:NSLayoutYAxisAnchor?,
                          topConstant: CGFloat,
                          leftConstant: CGFloat,
                          rigthConstant: CGFloat,
                          bottomConstant: CGFloat,
                          width: CGFloat,
                          height: CGFloat,
                          centerX: NSLayoutXAxisAnchor?,
                          centerY: NSLayoutYAxisAnchor?
        )
    {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rigthConstant).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if width > 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height > 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let centerX = centerX{
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY{
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
