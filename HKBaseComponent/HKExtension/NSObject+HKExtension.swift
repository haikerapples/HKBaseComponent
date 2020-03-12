//
//  NSobject+HKExtension.swift
//  swiftProject
//
//  Created by 王闯 on 2019/7/10.
//  Copyright © 2019 haiker. All rights reserved.
// 对象拓展

import Foundation

//对象拓展
extension NSObject{
    
    //获取属性名列表
    class func getPropertyNameArr() -> [String]? {
        var count = UInt32()
        
        guard let propertyArr = class_copyPropertyList(self, &count) else {
            return nil
        }
        var propertyNameArr = [String]()
        for i in 0..<Int(count) {
            let property = propertyArr[i]
            /// 获取属性名
            guard let name = self.getPropertyName(property)else {
                continue
            }
            propertyNameArr.append(name)
        }
        free(propertyArr)
        return propertyNameArr
    }
    
    //获取属性名
    private class func getPropertyName(_ property: objc_property_t) -> String? {
        let propertyName = property_getName(property)
        if let name = NSString(utf8String: propertyName){
            return name as String
        }
        
        return nil
    }
}
