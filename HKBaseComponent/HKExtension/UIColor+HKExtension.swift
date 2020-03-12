//
//  UIColor+HKExtension.swift
//  swiftProject
//
//  Created by 王闯 on 2019/7/17.
//  Copyright © 2019 haiker. All rights reserved.
//  颜色拓展

import Foundation

extension UIColor{
    
    
    /// 根据字符串, 获取颜色
    ///
    /// - Parameters:
    ///   - color: (支持 十六进制  -> 直接传字符串)
    ///            (支持 RGB     -> 用,隔开. 如 "234,40,133")
    ///            (支持 名字字符串 -> 如 "green")
    ///   - alpha: 透明度, 默认1
    /// - Returns: 颜色
    class func color(_ color : String , alpha : CGFloat = 1.0) -> UIColor {
        var temp = UIColor.clear
        if color.isEmpty {
            return temp
        }
        
        //十六进制
        let isHex = color.contains("#") || color.contains("0X") || color.contains("0x")
        if isHex {
            return self.hexColor(color , alpha: alpha)
        }
        
        //rgb
        let isRGB = color.contains(",")
        if isRGB {
            let arr = color.components(separatedBy: ",")
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            for (i,c) in arr.enumerated(){
                let cValue = c.cgfloat / 255.0
                if i == 0{
                    r = cValue
                }else if i == 1{
                    g = cValue
                }else{
                    b = cValue
                }
                
            }
            temp = UIColor(red: r, green: g, blue: b, alpha: alpha)
            return temp
        }
    
        //普通颜色字符串
        let sysColorArr = ["black","white","gray","red","blue","orange","purple","yellow","green","brown","darkGary","lightGray","cyan","magenta","clear"]
        var selStr = ""
        for c in sysColorArr{
            if color.contains(c){
                selStr = c + "Color"
                break
            }
        }
        let sel = NSSelectorFromString(selStr)
        if self.responds(to: sel){
            if let c = self.perform(sel){
                if let cc = c.takeRetainedValue() as? UIColor{
                    temp = cc
                    temp = temp.withAlphaComponent(alpha)
                }
            }
        }
        
        return temp
    }
    
    
    /// 十六进制颜色字符串, 获取颜色
    ///
    /// - Parameters:
    ///   - hex: 十六进制字符串
    ///   - alpha: 透明度, 默认1
    /// - Returns: 颜色
    class func hexColor(_ hex : String , alpha : CGFloat = 1.0) -> UIColor {
        var temp = UIColor.clear
        
        var str = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if str.isEmpty || str.length < 6 {
            return temp
        }
        if str.hasPrefix("#"){
            str = (str as NSString).substring(from: 1)
        }else if str.hasPrefix("0X"){
            str = (str as NSString).substring(from: 2)
        }
        
        if str.length != 6 {
            return temp
        }
        
        var rang = NSRange()
        rang.location = 0
        rang.length = 2
        
        let rStr = (str as NSString).substring(with: rang)
        rang.location = 2
        let gStr = (str as NSString).substring(with: rang)
        rang.location = 4
        let bStr = (str as NSString).substring(with: rang)
        
        var r : UInt32 = 0
        var g : UInt32 = 0
        var b : UInt32 = 0
        let rSuc = Scanner(string: rStr).scanHexInt32(&r)
        let gSuc = Scanner(string: gStr).scanHexInt32(&g)
        let bSuc = Scanner(string: bStr).scanHexInt32(&b)
        if rSuc && gSuc && bSuc{
            temp = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        }
        
        return temp
    }
    
    /// 获取随机颜色
    static func random() -> UIColor{
        let r = self.getRandom(0, to: 255)
        let g = self.getRandom(0, to: 255)
        let b = self.getRandom(0, to: 255)
        let str = "\(r)" + "," + "\(g)" + "," + "\(b)"
        return self.color(str)
    }
    
    /// 获取随机数. (如[1...3], 包含边界的数值)
    /// - Parameter from: 开始数字
    /// - Parameter to: 结束数字
    private static func getRandom(_ from : Int , to : Int) -> Int{
        if to < from {
            return 0
        }
        let x = arc4random() % UInt32((to - from + 1)) + UInt32(from)
        return Int(x)
    }
}
