//
//  UITableView+HKExtension.swift
//  DHProject
//
//  Created by MacBook on 2019/11/8.
//  Copyright © 2019 DHCC. All rights reserved.
//  UITableView拓展

import Foundation

extension UITableView{
    
    /// 处理空页面
    /// - Parameter dataCount: 数据源个数
    /// - Parameter icon: 图片
    /// - Parameter title: 标题
    /// - Parameter content: 自定义内容, view; 传自定义内容时, 就以自定义内容为准
    /// - Parameter block: 回调事件
    func dealEmpty(_ dataCount : Int, icon : String = "", title : String = "暂无数据", fromY : CGFloat = 0, content : UIView? = nil , block : (()->Void)? = nil){
        if dataCount == 0 {
            //let empty = HKTabEmptyView(self.bounds, icon: icon, title: title, content: content, block: block)
           
            
        }else{
            
        }
    }
}

extension UICollectionView{
    
    /// 处理空页面
    /// - Parameter dataCount: 数据源个数
    /// - Parameter icon: 图片
    /// - Parameter title: 标题
    /// - Parameter content: 自定义内容, view; 传自定义内容时, 就以自定义内容为准
    /// - Parameter block: 回调事件
    func dealEmpty(_ dataCount : Int, icon : String = "", title : String = "暂无数据", content : Any = "" , block : (()->Void)? = nil){
        if dataCount == 0 {
            //let empty = HKTabEmptyView(self.bounds, icon: icon, title: title, content: content, block: block)
            
        }else{
            
        }
    }
}
