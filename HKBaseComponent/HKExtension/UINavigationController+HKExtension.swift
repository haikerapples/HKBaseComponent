//
//  UINavigationController+HKExtension.swift
//  swiftProject
//
//  Created by 王闯 on 2019/7/10.
//  Copyright © 2019 haiker. All rights reserved.
//  导航栏的拓展

import Foundation

//UINavgationContrller拓展
extension UINavigationController{
    
    //如果状态栏由每个控制器控制,即在plist中设置交由子控制器管理的设置为YES, 如果想要
    //NAV的子控制器响应控制的方法, 需要加上这个
    open override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
}
