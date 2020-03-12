//
//  String+HKExtension.swift
//  swiftProject
//
//  Created by 王闯 on 2019/7/10.
//  Copyright © 2019 haiker. All rights reserved.
//  字符串拓展

import Foundation

//自定义属性
extension String{
    
    ///字符串自身 长度
    var length: Int {
        get{
            return NSString(string: self).length
        }
    }
    
    ///转换为int类型
    var int : Int {
        let tempStr = NSString(string: self)
        return tempStr.integerValue
    }
    
    ///转换为int32类型
    var int32 : Int32 {
        let tempStr = NSString(string: self)
        return tempStr.intValue
    }
    
    ///转换为int64类型
    var int64 : Int64 {
        let tempStr = NSString(string: self)
        return tempStr.longLongValue
    }
    
    ///转换为Double类型
    var double : Double {
        let tempStr = NSString(string: self)
        return tempStr.doubleValue
    }
    
    ///转换为Float类型
    var float : Float {
        let tempStr = NSString(string: self)
        return tempStr.floatValue
    }
    
    ///转换为CGFloat类型
    var cgfloat : CGFloat {
        let tempStr = NSString(string: self)
        return CGFloat(tempStr.floatValue)
    }
    
    ///转换为Bool类型
    var bool : Bool {
        let tempStr = NSString(string: self)
        return tempStr.boolValue
    }
}


//自定义方法
extension String{
    
    /// 字符串高度
    func height(_ font : UIFont? = nil, width : CGFloat) -> CGFloat {
        
        let label = UILabel()
        if let f = font{
            label.font = f
        }
        label.text = self
        let h = label.sizeThatFits(CGSize(width: width, height: 0)).height
        return h
    }
    
    /// 格式化数字字符串
    ///
    /// - Parameters:
    ///   - insert: 插入字符
    ///   - interval: 间隔数
    ///   - isForward: 是否正向. 默认false,即从右到左地插入
    /// - Returns: 格式化后的字符串. 如: 1,222,223,333.444545
    func format(insert : String , interval : UInt , isForward : Bool = false) -> String{
        
        var tempStr = ""
        
        //分割头尾
        var firstStr = ""
        var lastStr = ""
        if self.contains(".") == false {
            firstStr = self
        }else{
            let arr = self.components(separatedBy: ".")
            if arr.count > 1 {
                firstStr = arr.first!
                lastStr = arr.last!
            }else{
                if self.hasSuffix("."){
                    let s = (self as NSString).substring(to: self.length - 1)
                    firstStr = s
                }else{
                    firstStr = self
                }
            }
        }
        
        //分割数
        let intVerCount = Int(interval)
        
        let floatCount = Float(firstStr.length) / Float(intVerCount)
        //如果整数位 不够 分割的位数, 返回原字符串
        if floatCount <= 1 {
            return self
        }
        
        var count = Int(floatCount)
        //有多余位
        if firstStr.length % intVerCount != 0 {
            count = count + 1
        }
        
        //分割后的 字符串数组
        var sepArr = Array<String>()
        
        var pieceStr = ""
        var range = NSRange()
        for i in 1...count{
            //正序, 从左到右
            if isForward == true{
                if firstStr.length >= i * intVerCount{
                    range = NSRange(location: (i - 1) * intVerCount, length: intVerCount)
                }else{
                    range = NSRange(location: (i - 1) * intVerCount, length: firstStr.length - (i - 1) * intVerCount)
                }
                
                pieceStr = (firstStr as NSString).substring(with: range)
                //添加字符串
                sepArr.append(pieceStr)
                //逆序, 从右到左
            }else{
                if firstStr.length >= i * intVerCount{
                    range = NSRange(location: firstStr.length - i * intVerCount, length: intVerCount)
                }else{
                    range = NSRange(location: 0, length: firstStr.length - (i - 1) * intVerCount)
                }
                pieceStr = (firstStr as NSString).substring(with: range)
                //添加字符串
                sepArr.insert(pieceStr, at: 0)
            }
        }
        
        //字符串根据 分隔符 拼接
        tempStr = sepArr.joined(separator: insert)
        
        // 拼接 小数点后面的字符串
        if lastStr.length > 0 {
            tempStr = tempStr + "." + lastStr
        }
        
        return tempStr
    }
    
    /// 获取对应字符串在源字符串的位置数组
    ///
    /// - Parameter searchText: 需要查找的字符串
    /// - Returns: 字符串位置数组
    func rangArray(_ searchText : String) -> [NSRange]? {
        
        if searchText.length <= 0 || self.length <= 0{
            return nil
        }
        
        var rangArr = [NSRange]()
        //第一个查找字符串的位置
        let firstRange = (self as NSString).range(of: searchText)
        if firstRange.location != NSNotFound && firstRange.length != 0 {
            rangArr.append(firstRange)
            
            var tempRange = NSRange(location: 0, length: 0)
            var location = 0
            var leftLength = 0
            
            for i in 0...MAX_CANON{
                if i == 0{
                    location = firstRange.location + firstRange.length
                }else{
                    location = tempRange.location + tempRange.length
                }
                leftLength = self.length - location
                tempRange = NSRange(location: location, length: leftLength)
                //当前字符串的位置
                tempRange = (self as NSString).range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: tempRange)
                
                if tempRange.location != NSNotFound && tempRange.length != 0{
                    rangArr.append(tempRange)
                }else{
                    break
                }
            }
        }
        
        if rangArr.count <= 0 {
            return nil
        }
        
        return rangArr
    }
    
    /// 是否字母开头
    ///
    /// - Returns: 结果
    func hasPrefixCharacter() -> Bool {
        if self.isEmpty {
            return false
        }
        let character = "^[A-Z,a-z]+$"
        let predicate : NSPredicate = NSPredicate(format: "SELF MATCHES %@", character)
        return predicate.evaluate(with: self.prefix(1)) == true
    }
    
    /// 是否纯字母
    ///
    /// - Returns: 结果
    func isPureCharacter() -> Bool {
        if self.isEmpty {
            return false
        }
        let character = "^[A-Z,a-z]+$"
        let predicate : NSPredicate = NSPredicate(format: "SELF MATCHES %@", character)
        let temp = predicate.evaluate(with: self) == true
        return temp
    }
    
    /// 是否中文开头
    ///
    /// - Returns: 结果
    func hasPrefixChinese() -> Bool {
        
        if self.isEmpty {
            return false
        }
        let character = "^[\u{4E00}-\u{9FA5}]+$"
        let predicate : NSPredicate = NSPredicate(format: "SELF MATCHES %@", character)
        return predicate.evaluate(with: self.prefix(1)) == true
    }
    
    
    /// 是否包含中文
    ///
    /// - Returns: 结果
    func hasChineseIncluded() -> Bool {
        if self.isEmpty {
            return false
        }
        for (_,c) in self.enumerated(){
            if "\u{4E00}" <= c && c <= "\u{9FA5}" {
                return true
            }
        }
        return false
    }
    
    /// 是否纯中文
    ///
    /// - Returns: 结果
    func isPureChinese() -> Bool {
        if self.isEmpty {
            return false
        }
        var temp = true
        for (_,c) in self.enumerated(){
            if "\u{4E00}" > c || c > "\u{9FA5}" {
                temp = false
                break
            }
        }
        return temp
    }
    
    
    /// 是否纯 int 类型整数
    func isPurnInt() -> Bool {
        if self.isEmpty {
            return false
        }
        //扫描字符串
        let scan : Scanner =  Scanner(string: self)
        var t : Int = 0
        
        return scan.scanInt(&t) && scan.isAtEnd
    }
    
    /// 是否整数 /浮点数
    func isPureNumber() -> Bool {
        if self.isEmpty {
            return false
        }
        var isNum : Bool = false
        //是否纯数字
        let isInt = self.isPurnInt()
        if isInt {
            isNum = true
        }else{
            //是否浮点数
            //去掉小数点, 是否纯数字
            let temp = self.replacingOccurrences(of: ".", with: "")
            if temp.isPurnInt() == false {
                isNum = false
            }else{
                //是否多个小数点
                if let firstIndex = self.firstIndex(of: "."), let lastIndex = self.lastIndex(of: "."){
                    //只有一个小数点
                    if firstIndex == lastIndex{
                        //小数点在中间
                        if self.indices.first! < firstIndex && firstIndex < self.indices.last!{
                            isNum = true
                        }
                    }
                }
            }
        }
        
        return isNum
    }
    
    
    /// 获取date对象
    /// - Parameter dateFormat: 字符串时间格式
    func date(_ dateFormat : String) -> Date? {
        if self.isEmpty {
            return nil
        }
        
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormat
        let date = fmt.date(from: self)
        return date
    }
    
    
    /// 获取格式化的时间字符串
    /// - Parameter orgFormat: 原始字符串的时间格式
    /// - Parameter toFormat: 需要转换成的时间格式
    func dateString(_ orgFormat : String , toFormat : String) -> String {
        var temp = ""
        if let date = self.date(orgFormat){
            let fmt = DateFormatter()
            fmt.dateFormat = toFormat
            temp = fmt.string(from: date)
        }
        return temp
    }
    
    /// 时间戳字符串 转换成 对应格式字符串
    /// - Parameter secondRate: 秒的比率. 如果时间戳是秒, 则为1; 如果时间戳是毫秒,则为1000
    /// - Parameter toFormat: 需要转换成的时间格式
    func timestampString(_ secondRate : UInt , toFormat : String) -> String {
        let timeInv = self.double / Double(secondRate)
        let date = Date(timeIntervalSince1970: timeInv)
        let fmt = DateFormatter()
        fmt.dateFormat = toFormat
        let temp = fmt.string(from: date)
        return temp
    }
    
    /// 获取时间字符串,对应时间的前几天/后几天的 那一天的0点 和 23:59:59时刻的时间戳
    /// - Parameter orgFormat: 原始时间字符串的时间格式
    /// - Parameter days: 前几天/后几天/当天.  0:当天, 正数: 当天的未来几天, 负数: 当天的前几天
    /// - (begin , end): begin为该天的0时时间戳; end为该天23:59:59时时间戳. (单位: 秒)
    func timestamp(_ orgFormat : String , forward days : Int = 0) -> (begin : TimeInterval , end : TimeInterval) {
        var begin : TimeInterval = 0
        var end : TimeInterval = 0
        
        //一天的秒数
        let dayInv : TimeInterval = 24 * 60 * 60
        //差值天数的秒时间
        let invSecond : TimeInterval = dayInv * TimeInterval(days)
            
        //时间戳字符串, 那天的0点及23:59:59时间戳
        if let date = self.date(orgFormat){
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            let beginStr = fmt.string(from: date)
            if let beginDate = fmt.date(from: beginStr){
                begin = beginDate.timeIntervalSince1970
                end = begin + dayInv - 1
                
                //加上差值
                begin = begin + invSecond
                end = end + invSecond
            }
        }
        
        return (begin , end)
    }
    
    /// 获取字符串对应时间的前几天/后几天的 那一天的0点 和 23:59:59时刻的时间戳
    /// - Parameter secondRate: 秒的比率. 如果时间戳是秒, 则为1; 如果时间戳是毫秒,则为1000
    /// - Parameter days: 前几天/后几天/当天.  0:当天, 正数: 当天的未来几天, 负数: 当天的前几天
    /// - (begin , end): begin为该天的0时时间戳; end为该天23:59:59时时间戳. (单位: 秒)
    func timestamp(_ secondRate : UInt , forward days : Int = 0) -> (begin : TimeInterval , end : TimeInterval) {
        var begin : TimeInterval = 0
        var end : TimeInterval = 0
        
        //一天的秒数
        let dayInv : TimeInterval = 24 * 60 * 60
        //差值天数的秒时间
        let invSecond : TimeInterval = dayInv * TimeInterval(days)
            
        //时间戳字符串, 那天的0点及23:59:59时间戳
        let timeInv = self.double / Double(secondRate)
        let date = Date(timeIntervalSince1970: timeInv)
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let beginStr = fmt.string(from: date)
        if let beginDate = fmt.date(from: beginStr){
            begin = beginDate.timeIntervalSince1970
            end = begin + dayInv - 1
            
            //加上差值
            begin = begin + invSecond
            end = end + invSecond
        }
       
        return (begin , end)
    }
    
    
    /// 获取时间差值字符串. 比如"刚刚, 1小时前等"
    /// - Parameter dateFormat: 原始字符串的时间格式
    /// - Parameter date: 截止时间. 默认当前时间
    func timeDistance(_ dateFormat : String , deadline date : Date = Date()) -> String {
        var temp = ""
        if let orgDate = self.date(dateFormat) {
            let cal = Calendar.current
            let unit : Set<Calendar.Component> = [Calendar.Component.year ,Calendar.Component.month ,Calendar.Component.day ,Calendar.Component.hour ,Calendar.Component.minute ,Calendar.Component.second ,]
            let cmp = cal.dateComponents(unit, from: orgDate, to: date)
            
            if let year = cmp.year , let month = cmp.month , let day = cmp.day , let hour = cmp.hour, let minute = cmp.minute , let _ = cmp.second{
                var comTemp = ""
                if year == 0 {
                    comTemp = "今年"
                    //当月
                    if month == 0 {
                        //今天, 昨天, 前天
                        if day <= 2 {
                            if day == 0 {
                                comTemp = "今天"
                                if hour > 0 {
                                    comTemp = "\(hour)小时前"
                                }else{
                                    if minute > 0 {
                                        comTemp = "\(minute)分钟前"
                                    }else{
                                        //1分钟之内
                                        comTemp = "刚刚"
                                    }
                                }
                                temp = comTemp
                            }else if day == 1{
                                //昨天 12:00:00
                                comTemp = "昨天"
                                temp = comTemp + " " + self.dateString(dateFormat, toFormat: "HH:mm:ss")
                            }else if day == 2{
                                //前天 12:00:00
                                comTemp = "前天"
                                temp = comTemp + " " + self.dateString(dateFormat, toFormat: "HH:mm:ss")
                            }
                            
                        }else{
                            //今年6月6日 12:00:00
                            temp = comTemp + "" + self.dateString(dateFormat, toFormat: "MM月dd日 HH:mm:ss")
                        }
                    }else{
                        //今年6月6日 12:00:00
                        temp = comTemp + "" + self.dateString(dateFormat, toFormat: "MM月dd日 HH:mm:ss")
                    }
                }else{
                    //2019年6月6日 12:00:00
                    temp = self.dateString(dateFormat, toFormat: "yyyy年MM月dd日 HH:mm:ss")
                }
            }
            
        }
        return temp
    }
    
    //unicode 转码
    func unicodeFormat() -> String{
        if self.contains("\\u") == false && self.contains("\\U") == false{
            return self
        }
        
        //转码
        var str : String = self
        let temp1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let temp2 = temp1.replacingOccurrences(of: "\"", with: "\\\"")
        let temp3 = "\"".appending(temp2).appending("\"")
        if let data = temp3.data(using: String.Encoding.utf8){
            do {
                if let s = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainers], format: nil) as? String{
                    str = s
                    str = str.replacingOccurrences(of: "\\r\\n", with: "\n")
                }
            } catch {
                //print("字符串 Unicode 转码失败, error = \(error.localizedDescription)")
            }
        }
        return str
    }
}
