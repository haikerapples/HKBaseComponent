//
//  HKTabEmptyView.swift
//  DHProject
//
//  Created by MacBook on 2019/11/8.
//  Copyright © 2019 DHCC. All rights reserved.
//

import UIKit
import Foundation

class HKTabEmptyView: UIView {

    //图标
    var icon : String = ""
    
    //标题
    var title : String = ""
    
    //自定义view内容
    var content : UIView?
    
    //回调
    var block : (()->Void)?
    

    lazy var iconImageView: UIImageView = {
        let iconWH : CGFloat = 100
        let view = UIImageView()
        view.frame = CGRect(x: (self.width - iconWH) * 0.5, y: (self.height - iconWH) * 0.5, width: iconWH, height: iconWH)
        return view
    }()
    
    lazy var desLabel: UILabel = {
        let view = UILabel()
        view.frame = CGRect(x: 15, y: self.iconImageView.frame.maxY + 10, width: self.width - 15 * 2, height: 30)
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = UIColor.color("#666666")
        return view
    }()
    
    /// 创建控件
    /// - Parameter frame: 位置大小
    /// - Parameter icon: 图标
    /// - Parameter title: 标题
    /// - Parameter content: 自定义内容
    /// - Parameter block: 回调
    convenience init(_ frame : CGRect ,icon : String = "", title : String = "暂无数据", content : UIView? = nil , block : (()->Void)? ) {
        self.init(frame:frame)
        self.icon = icon
        self.title = title
        self.content = content
        self.block = block
        
        self.buildUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HKTabEmptyView{
    
    func buildUI() -> Void {
        
        self.backgroundColor = UIColor.clear
        
        //自定义view
        if let contentView = self.content {
            self.addSubview(contentView)
            return
        }
            
        self.addSubview(self.iconImageView)
        self.addSubview(self.desLabel)
        //image
        self.iconImageView.image = UIImage(named: self.icon)
        //label
        self.desLabel.text = self.title
        let desH = self.desLabel.sizeThatFits(self.desLabel.size).height
        self.desLabel.height = desH
        
        //点击事件
        self.addTapGes { (tap) in
            if let cb = self.block{
                cb()
            }
        }
    }
}
