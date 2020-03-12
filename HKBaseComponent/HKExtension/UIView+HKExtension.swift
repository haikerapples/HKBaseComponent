//
//  UIView+HKExtension.swift
//  swiftProject
//
//  Created by MacBook on 2019/8/14.
//  Copyright © 2019 haiker. All rights reserved.
//  UIView 拓展

import Foundation

///渐变方向枚举
enum HKGradualDirection {
    case top     //上 -> 下
    case bottom  //下 -> 上
    case left    //左 -> 右
    case right   //右 -> 左
    
    case diagonal_leftTop     //对角线 左上 -> 右下
    case diagonal_leftBottom  //对角线 左下 -> 右上
    case diagonal_rightTop    //对角线 右上 -> 左下
    case diagonal_rightBottom //对角线 右下 -> 左上
    
    //起始点, 终点
    var point : (start : CGPoint , end : CGPoint){
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        switch self {
        case .top:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .bottom:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        case .left:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)
        case .right:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 0)
        case .diagonal_leftTop:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 1)
        case .diagonal_leftBottom:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 0)
        case .diagonal_rightTop:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .diagonal_rightBottom:
            startPoint = CGPoint(x: 1, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        //default:break
        }
        return (startPoint , endPoint)
    }
}

//手势类型枚举
enum HKGestureType {
    case tap       //点击
    case pan       //拖拽
    case swipe     //轻扫
    case longPress //长按
    case rotation  //旋转
    case pinch     //捏合
}

//frame 相关
extension UIView{
    
    /// x值
    var x : CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    
    /// y值
    var y : CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    
    /// width值
    var width : CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    
    /// height值
    var height : CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    
    /// 中心点x值
    var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    
    /// 中心点y值
    var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
    
    /// size值
    var origin : CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.frame.origin = newValue
        }
    }
    
    /// maxX值
    var maxX : CGFloat{
        get{
            return self.frame.maxX
        }
    }
    /// maxX值
    var minX : CGFloat{
        get{
            return self.frame.minX
        }
    }
    /// mid值
    var midX : CGFloat{
        get{
            return self.frame.midX
        }
    }
    
    /// maxY值
    var maxY : CGFloat{
        get{
            return self.frame.maxY
        }
    }
    /// minY值
    var minY : CGFloat{
        get{
            return self.frame.minY
        }
    }
    /// maxY值
    var midY : CGFloat{
        get{
            return self.frame.midY
        }
    }
    
    /// size值
    var size : CGSize{
        get{
            return self.frame.size
        }
        set{
            self.frame.size = newValue
        }
    }
    
}

//手势相关
extension UIView : UIGestureRecognizerDelegate{
    
    ///点按回调key
    fileprivate static var HKGestureCallBackKey_tap = "HKGestureCallBackKey_tap"
    ///拖拽回调key
    fileprivate static var HKGestureCallBackKey_pan = "HKGestureCallBackKey_pan"
    ///轻扫回调key
    fileprivate static var HKGestureCallBackKey_swipe = "HKGestureCallBackKey_swipe"
    ///长按回调key
    fileprivate static var HKGestureCallBackKey_longPress = "HKGestureCallBackKey_longPress"
    ///旋转回调key
    fileprivate static var HKGestureCallBackKey_rotation = "HKGestureCallBackKey_rotation"
    ///捏合回调key
    fileprivate static var HKGestureCallBackKey_pinch = "HKGestureCallBackKey_pinch"
    
    /// 添加手势
    /// - Parameter gestures: 手势类型数组,支持多种手势组合
    /// - Parameter callBack: 手势回调.(返回手势对象)
    func addGesture(_ gestures : [HKGestureType] , callBack:((UIGestureRecognizer)->Void)?){
        
        //无手势
        if gestures.isEmpty {
            //HKToolBox.log.log("手势类型为空, 请核查")
            return
        }
        
        //添加手势
        for (_ , gesType) in gestures.enumerated() {
            switch gesType {
            case .tap:
                self.addTapGes(callBack)
            case .pan:
                self.addPanGes(callBack)
            case .swipe:
                self.addSwipeGes(callBack)
            case .longPress:
                self.addLongPressGes(callBack)
            case .rotation:
                self.addRotationGes(callBack)
            case .pinch:
                self.addPinchGes(callBack)
//            default:
//                break
            }
        }
        
    }
    
    /// 添加点按手势
    /// - Parameter callBack: 回调
    func addTapGes(_ callBack : ((UITapGestureRecognizer)->Void)?) {
        //有手势, 检测是否允许交互
        if self.isUserInteractionEnabled == false {
            self.isUserInteractionEnabled = true
        }
        
        //引用回调
        if let cb = callBack{
            objc_setAssociatedObject(self, &(UIView.HKGestureCallBackKey_tap), cb, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.addGestureRecognizer(ges)
    }
    @objc fileprivate func tap(_ ges : UITapGestureRecognizer) {
        if let cb = objc_getAssociatedObject(self, &(UIView.HKGestureCallBackKey_tap)) as? (UITapGestureRecognizer)->Void{
            cb(ges)
        }
    }
    
    /// 添加拖动手势
    /// - Parameter callBack: 回调
    func addPanGes(_ callBack : ((UIPanGestureRecognizer)->Void)?) {
        //有手势, 检测是否允许交互
        if self.isUserInteractionEnabled == false {
            self.isUserInteractionEnabled = true
        }
        
        //引用回调
        if let cb = callBack{
            objc_setAssociatedObject(self, &(UIView.HKGestureCallBackKey_pan), cb, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        let ges = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        self.addGestureRecognizer(ges)
    }
    @objc fileprivate func pan(_ ges : UIPanGestureRecognizer) {
        //获取偏移量,获取的偏移量是相对于最原始的点
        let transPoint = ges.translation(in: ges.view)
        
        //注意:不能使用带make的,带make的只一次性有效,下一次还是相对于原始点做位移
        let t = CGAffineTransform.translatedBy(self.transform)
        self.transform = t(transPoint.x, transPoint.y)
        
        //清0操作(不让偏移量进行累加,获取的是相对于上一次的值,每一次走的值.)
        ges.setTranslation(CGPoint.zero, in: ges.view)
        
        //回调
        if let cb = objc_getAssociatedObject(self, &(UIView.HKGestureCallBackKey_pan)) as? (UIPanGestureRecognizer)->Void{
            cb(ges)
        }
    }
    
    /// 添加轻扫手势
    /// - Parameter callBack: 回调
    func addSwipeGes(_ callBack : ((UISwipeGestureRecognizer)->Void)?) {
        //有手势, 检测是否允许交互
        if self.isUserInteractionEnabled == false {
            self.isUserInteractionEnabled = true
        }
        
        //引用回调
        if let cb = callBack{
            objc_setAssociatedObject(self, &(UIView.HKGestureCallBackKey_swipe), cb, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        let ges = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        ges.direction = .left
        self.addGestureRecognizer(ges)
        
        let ges1 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        ges1.direction = .right
        self.addGestureRecognizer(ges1)
        
        let ges2 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        ges2.direction = .up
        self.addGestureRecognizer(ges2)
        
        let ges3 = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        ges3.direction = .down
        self.addGestureRecognizer(ges3)
    }
    @objc fileprivate func swipe(_ ges : UISwipeGestureRecognizer) {
        if let cb = objc_getAssociatedObject(self, &(UIView.HKGestureCallBackKey_swipe)) as? (UISwipeGestureRecognizer)->Void{
            cb(ges)
        }
    }
    
    /// 添加长按手势
    /// - Parameter callBack: 回调
    func addLongPressGes(_ callBack : ((UILongPressGestureRecognizer)->Void)?) {
        //有手势, 检测是否允许交互
        if self.isUserInteractionEnabled == false {
            self.isUserInteractionEnabled = true
        }
        
        //引用回调
        if let cb = callBack{
            objc_setAssociatedObject(self, &(UIView.HKGestureCallBackKey_longPress), cb, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        self.addGestureRecognizer(ges)
    }
    @objc fileprivate func longPress(_ ges : UILongPressGestureRecognizer) {
        if let cb = objc_getAssociatedObject(self, &(UIView.HKGestureCallBackKey_longPress)) as? (UILongPressGestureRecognizer)->Void{
            cb(ges)
        }
    }
    
    /// 添加旋转手势
    /// - Parameter callBack: 回调
    func addRotationGes(_ callBack : ((UIRotationGestureRecognizer)->Void)?) {
        //有手势, 检测是否允许交互
        if self.isUserInteractionEnabled == false {
            self.isUserInteractionEnabled = true
        }
        
        //引用回调
        if let cb = callBack{
            objc_setAssociatedObject(self, &(UIView.HKGestureCallBackKey_rotation), cb, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        let ges = UIRotationGestureRecognizer(target: self, action: #selector(self.rotation(_:)))
        ges.delegate = self
        self.addGestureRecognizer(ges)
    }
    @objc fileprivate func rotation(_ ges : UIRotationGestureRecognizer) {
        
        //获取旋转角度(已经是弧度),相对于最原始的弧度
        let rotatinon = ges.rotation
        let t = CGAffineTransform.rotated(ges.view!.transform)
        self.transform = t(rotatinon)
        //清0
        ges.rotation = 0
        
        if let cb = objc_getAssociatedObject(self, &(UIView.HKGestureCallBackKey_rotation)) as? (UIRotationGestureRecognizer)->Void{
            cb(ges)
        }
    }
    
    /// 添加捏合手势
    /// - Parameter callBack: 回调
    func addPinchGes(_ callBack : ((UIPinchGestureRecognizer)->Void)?) {
        //有手势, 检测是否允许交互
        if self.isUserInteractionEnabled == false {
            self.isUserInteractionEnabled = true
        }
        
        //引用回调
        if let cb = callBack{
            objc_setAssociatedObject(self, &(UIView.HKGestureCallBackKey_pinch), cb, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        let ges = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(_:)))
        ges.delegate = self
        self.addGestureRecognizer(ges)
    }
    @objc fileprivate func pinch(_ ges : UIPinchGestureRecognizer) {
        
        //获取缩放比例(相对于最原始的比例)
        let scale = ges.scale
        let t = CGAffineTransform.scaledBy(ges.view!.transform)
        self.transform = t(scale , scale)
        //重置
        ges.scale = 1.0
        
        if let cb = objc_getAssociatedObject(self, &(UIView.HKGestureCallBackKey_pinch)) as? (UIPinchGestureRecognizer)->Void{
            cb(ges)
        }
    }
    
    //是否支持多手势
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        //有多个手势时, 支持多手势
//        if let gesArr = self.gestureRecognizers{
//            return gesArr.count > 1 ? true : false
//        }
//        return false
//    }
    
}

extension UIView{
    
    /// 添加渐变色
    ///
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 渐变位置数组. (0~1.0之间 , 不设置默认按照系统样式)
    ///   - direction: 渐变方向. (默认从左到右)
    ///   - frame: 位置大小. (不设置时默认为View大小)
    /// - Returns: layer对象. (返回layer对象给外界,外界获取到layer对象可以设置其他
    ///                       个性化属性,不需要时则不用接收)
    func addGradual(_ colors : [UIColor] , locations : [CGFloat]? = nil ,from direction : HKGradualDirection = .left , frame : CGRect = CGRect.zero) -> CALayer?{
        
        //容错
        if colors.isEmpty {
            return nil
        }
        
        //渐变层
        let layer = CAGradientLayer()
        self.layer.addSublayer(layer)
        layer.frame = frame == CGRect.zero ? self.bounds : frame
        
        //颜色数组
        let cgColorArr = colors.map { (c) -> CGColor in
            return c.cgColor
        }
        layer.colors = cgColorArr
        
        //位置数组
        if let locations = locations{
            let locationArr = locations.map { (f) -> NSNumber in
                return NSNumber(value: Float(f))
            }
            layer.locations = locationArr
        }
        
        //方向
        layer.startPoint = direction.point.start
        layer.endPoint = direction.point.end
        return layer
    }
    
    
    /// 添加阴影
    /// - Parameter shadowColor: 阴影颜色
    /// - Parameter shadowRadius: 阴影半径
    /// - Parameter shadowOffset: 阴影方向
    func addShadow(_ shadowColor : UIColor = UIColor.color("#000000" , alpha : 0.1) , shadowRadius : CGFloat = 8 , shadowOffset : CGSize = CGSize.zero) {
        
        //添加阴影, 如果设置true, 阴影就会被剪裁掉,所以这里主动设置为false
        if self.layer.masksToBounds == true {
            self.layer.masksToBounds = false
        }
        
        //颜色
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.borderColor = self.layer.shadowColor
        self.layer.borderWidth = 0.1
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    
    /// 截屏
    /// - Parameter isShake: 是否震动. 默认false
    /// - Parameter soundType: 是否截屏声音类型. 默认无
    func screenshot(_ isShake : Bool = false , soundType : HKAudioSoundType = HKAudioSoundType.none) -> UIImage? {
        
        //容错
        if self.size == CGSize.zero {
            return nil
        }
        
        //声音
        soundType.play(isShake)
        
        //获取图片
        var image : UIImage?
        UIGraphicsBeginImageContextWithOptions(self.size, true, UIScreen.main.scale)
        if let ctx = UIGraphicsGetCurrentContext(){
            self.layer.render(in: ctx)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}

public struct UIRectSide : OptionSet {

    public let rawValue: Int

    public static let left = UIRectSide(rawValue: 1 << 0)

    public static let top = UIRectSide(rawValue: 1 << 1)

    public static let right = UIRectSide(rawValue: 1 << 2)

    public static let bottom = UIRectSide(rawValue: 1 << 3)

    public static let all: UIRectSide = [.top, .right, .left, .bottom]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension UIView{

    ///画虚线边框
    func drawDashLine(_ strokeColor: UIColor, lineWidth: CGFloat = 0.5, lineLength: Int = 5, lineSpacing: Int = 5, corners: UIRectSide = .all) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        if corners.contains(.left) {
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }

        if corners.contains(.top){
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
        }

        if corners.contains(.right){
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
        }

        if corners.contains(.bottom){
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
        }
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }

    ///画实线边框
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat = 0.5, corners: UIRectSide = .all) -> CAShapeLayer? {

        if corners == UIRectSide.all {
            self.layer.borderWidth = lineWidth
            self.layer.borderColor = strokeColor.cgColor
            return nil
        }else{
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = self.bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            
            let path = CGMutablePath()
            if corners.contains(.left) {
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }

            if corners.contains(.top){
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            }

            if corners.contains(.right){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            }

            if corners.contains(.bottom){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            }
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
            return shapeLayer
        }
    }

}
