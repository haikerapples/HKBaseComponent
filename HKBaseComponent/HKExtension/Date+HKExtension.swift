//
//  Date+HKExtension.swift
//  swiftProject
//
//  Created by MacBook on 2019/8/28.
//  Copyright © 2019 haiker. All rights reserved.
//  时间拓展

import Foundation

//自定义属性
extension Date{
    
    //是否今年
    var isThisYear : Bool{
        get{
            var temp : Bool = false
            let cmp = self.components([Calendar.Component.year,])
            if let y = cmp.year{
                if y == 0 {
                    temp = true
                }
            }
            return temp
        }
    }
    
    //是否当月
    var isThisMonth : Bool{
        get{
            var temp : Bool = false
            let cmp = self.components([Calendar.Component.year,.month])
            if let y = cmp.year , let m = cmp.month{
                if y == 0 && m == 0{
                    temp = true
                }
            }
            return temp
        }
    }
    
    //是否今天
    var isToday : Bool{
        get{
            var temp : Bool = false
            let cmp = self.components([Calendar.Component.year, .month, .day])
            if let y = cmp.year , let m = cmp.month , let d = cmp.day{
                if y == 0 && m == 0 && d == 0 {
                    temp = true
                }
            }
            return temp
        }
    }
    
    //是否昨天
    var isYesterday : Bool{
        get{
            var temp : Bool = false
            let cmp = self.components([Calendar.Component.year, .month, .day])
            if let y = cmp.year , let m = cmp.month , let d = cmp.day{
                if y == 0 && m == 0 && d == 1 {
                    temp = true
                }
            }
            return temp
        }
    }
    
    //是否前天
    var isTheDayBeforeYesterday : Bool{
        get{
            var temp : Bool = false
            let cmp = self.components([Calendar.Component.year, .month, .day])
            if let y = cmp.year , let m = cmp.month , let d = cmp.day{
                if y == 0 && m == 0 && d == 2 {
                    temp = true
                }
            }
            return temp
        }
    }
    
}


//自定义方法
extension Date{
    
    /// 获取和某个日期的 差值组件
    /// - Parameter unit: 需要差值的类型数组. 如[.year , .month]
    /// - Parameter date: 截止日期. 默认当前时间
    func components(_ unit : [Calendar.Component] , deadline date : Date = Date()) -> DateComponents {
       let cla = Calendar.current
       var u : Set<Calendar.Component> = Set()
       unit.forEach { (c) in
           u.insert(c)
       }
       let cmp = cla.dateComponents(u, from: self, to: date)
       return cmp
    }
    
    /// 转换成对应格式字符串
    /// - Parameter dateFormat: 日期字符串
    func string(_ dateFormat : String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormat
        let temp = fmt.string(from: self)
        return temp
    }
}
