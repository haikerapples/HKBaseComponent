//
//  Data+HKExtension.swift
//  swiftProject
//
//  Created by MacBook on 2019/8/29.
//  Copyright © 2019 haiker. All rights reserved.
//  Data拓展

import Foundation

//自定义属性
extension Data{
    
    /// 二进制图片类型
    var imageType : HKImageType{
        get{
            var temp : HKImageType = .unknown
            var c : UInt8 = 0
            self.copyBytes(to: &c, count: 1)
            switch c {
            case 0x89:
                temp = .png
            case 0xFF:
                //jpg 和 jpeg的值一样, 这里统一为jpg类型
                temp = .jpg
            case 0x47:
                temp = .gif
            default:
                break
            }
            
            return temp
        }
    }
}

//自定义方法
extension Data{
    
    
}
