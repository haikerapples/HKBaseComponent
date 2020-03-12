//
//  UIImage+HKExtension.swift
//  swiftProject
//
//  Created by MacBook on 2019/8/14.
//  Copyright © 2019 haiker. All rights reserved.
//  图片拓展

import Foundation
import AVFoundation

//图片类型
enum HKImageType{
    case unknown
    case png
    case jpg
    case jpeg
    case gif
    
    //类型
    var form : String{
        var temp = "未知"
        switch self {
        case .unknown:
            temp = "未知"
        case .png:
            temp = "png"
        case .jpeg:
            temp = "jpeg"
        case .jpg:
            temp = "jpg"
        case .gif:
            temp = "gif"
        //default:break
        }
        return temp
    }
}

//剪裁的形状
enum HKImageClipShape {
    case circle //圆形
    case square //矩形
}

//自定义属性
extension UIImage{
    
    //存储image data的key
    fileprivate static var HKImageDataKey = "HKImageDataKey"
    
    /// 是否GIF图片
    var isGif : Bool{
        get{
            var temp : Bool = false
            if let d = self.data{
                temp = d.imageType == .gif
            }
            return temp
        }
    }
    
    /// 二进制数据
    var data : Data?{
        get{
            var temp : Data?
            //获取关联对象
            if let d = objc_getAssociatedObject(self, &(UIImage.HKImageDataKey)) as? Data{
                temp = d
            }
            return temp
        }
    }
}

//自定义方法
extension UIImage{
    
    /// 获取图片
    /// - Parameter name: 图片名称. (支持GIF,如 1.gif)
    /// - Parameter size: 需要的尺寸
    /// - Parameter renderColor: 渲染颜色
    static func image(_ name : String , size : CGSize = CGSize.zero , renderColor : UIColor? = nil) -> UIImage?{
        var temp : UIImage?
        if name.isEmpty{
            return temp
        }
        
        //二进制
        var imgData : Data?
        //全路径
        if name.contains(Bundle.main.bundlePath) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: name)){
                imgData = data
            }
        //名称类型
        }else{
            //后缀类型
            let supportArr = [HKImageType.png.form , HKImageType.jpg.form , HKImageType.jpeg.form, HKImageType.gif.form,]
            let tempName = name.lowercased()
            //是否有后缀
            var isHasSuffix = false
            for t in supportArr{
                //以.XX结尾, 如 .png
                let s = "." + t
                if tempName.hasSuffix(s){
                    isHasSuffix = true
                    break
                }
            }
            //文件路径
            var path : String = ""
            //无后缀, 加后缀加载
            if isHasSuffix == false {
                for t in supportArr{
                    if let p = Bundle.main.path(forResource: name, ofType: t){
                        path = p
                        break
                    }
                }
                //未找到, 加@2x,
                if path.isEmpty {
                    //寻找适配的@x图片
                    let scaleStr = UIScreen.main.scale <= 2 ? "@2x" : "@3x"
                    for t in supportArr{
                        if let p = Bundle.main.path(forResource: name + scaleStr, ofType: t){
                            path = p
                            break
                        }
                    }
                    
                    //未找到适配的@x图片, 可能只配了一种图片,寻找另一种
                    if path.isEmpty {
                        //寻找另一种的@x图片
                        let anotherScaleStr = scaleStr == "@2x" ? "@3x" : "@2x"
                        for t in supportArr{
                            if let p = Bundle.main.path(forResource: name + anotherScaleStr, ofType: t){
                                path = p
                                break
                            }
                        }
                    }
                }
            //有后缀, 直接加载
            }else{
                if let p = Bundle.main.path(forResource: name, ofType: nil){
                    path = p
                }
            }
            //获取二进制
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                imgData = data
            }
        }
        
        //gif判断
        var isGif : Bool = false
        if let d = imgData{
            //引用data
            objc_setAssociatedObject(self, &(UIImage.HKImageDataKey), d, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            isGif = d.imageType == .gif
        }
        
        //GIF类型
        if isGif{
            if let d = imgData{
                temp = UIImage.gifImage(d, size: size, renderColor: renderColor)
            }
        //非GIF
        }else{
            if let d = imgData{
                temp = UIImage(data: d)
            }else{
                if temp == nil {
                    temp = UIImage(named: name)
                }
            }
            //重绘大小及颜色
            if let img = temp {
                temp = img.image(size, renderColor: renderColor)
            }
        }
        return temp
    }
    
    /// 重绘图片大小及颜色
    /// - Parameter size: 大小. 默认图片本身大小
    /// - Parameter renderColor: 渲染线条的颜色.
    func image(_ size : CGSize = CGSize.zero , renderColor : UIColor? = nil) -> UIImage? {
        
        var temp : UIImage?
        //原始尺寸
        if size == CGSize.zero {
            if renderColor == nil {
                temp = self
            }else{
                //渲染色
                UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
                let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
                renderColor!.setFill()
                UIRectFill(bounds)
                //改变线条颜色
                self.draw(in: bounds, blendMode: CGBlendMode.destinationAtop, alpha: 1.0)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                temp = img
                UIGraphicsEndImageContext()
            }
        }else{
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            //渲染色
            if renderColor == nil {
                self.draw(in: bounds)
            }else{
                renderColor!.setFill()
                UIRectFill(bounds)
                self.draw(in: bounds, blendMode: CGBlendMode.destinationAtop, alpha: 1.0)
            }
            let img = UIGraphicsGetImageFromCurrentImageContext()
            temp = img
            UIGraphicsEndImageContext()
        }
        
        return temp
    }
    
    /// 获取GIF图片
    /// - Parameter data: 图片二进制
    /// - Parameter size: 需要的尺寸
    /// - Parameter renderColor: 渲染颜色
    static func gifImage(_ data : Data , size : CGSize = CGSize.zero , renderColor : UIColor? = nil) -> UIImage?{
        var temp : UIImage?
        //资源
        guard let source = CGImageSourceCreateWithData(data as CFData, nil)else{
            return temp
        }
        //帧数
        let count = CGImageSourceGetCount(source)
        if count <= 1 {
            temp = UIImage(data: data)
        }else{
            var duration : TimeInterval = 0
            var imageArr = [UIImage]()
            for i in 0..<count {
                //累计时间
                let t = self.getGIFTime(i , source : source)
                duration = duration + t
                
                //为0的过滤
                if t > 0 {
                    //cgImage
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil){
                        var img = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
                        //尺寸,渲染
                        if let reImg = img.image(size, renderColor: renderColor){
                            img = reImg
                        }
                        imageArr.append(img)
                    }
                }
            }
            if imageArr.isEmpty == false && duration != 0 {
                temp = UIImage.animatedImage(with: imageArr, duration: duration)
            }
        }
        return temp
    }
    
    
    /// 获取GIF图片资源中某一帧图片的时长
    /// - Parameter index: 帧坐标
    /// - Parameter source: 资源
    fileprivate static func getGIFTime(_ index : Int , source : CGImageSource) -> TimeInterval {
        var temp : TimeInterval = 0
        //当前帧的信息
        if let dic = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any]{
            //GIF信息
            if let gifDic = dic[kCGImagePropertyGIFDictionary as String] as? [String : Any]{
                var num : NSNumber?
                num = gifDic[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
                if num == nil {
                    num = gifDic[kCGImagePropertyGIFDelayTime as String] as? NSNumber
                }
                if let num = num{
                    temp = TimeInterval(num.floatValue)
                }
            }
        }
        return temp
    }
    
    
    /// 获取视频的某一帧的截图
    /// - Parameter vedio: 视频资源. (本地资源时,为名称; 网络视频时, 为url路径)
    /// - Parameter index: 第几帧. 默认第一帧
    static func screenshot(_ vedio : String , index : Int = 1) -> UIImage?{
        var temp : UIImage?
        if vedio.isEmpty {
            return temp
        }
        var url : URL?
        //全路径
        if vedio.contains(Bundle.main.bundlePath) {
            url = URL(fileURLWithPath: vedio)
        }else{
            //本地尝试
            if let path = Bundle.main.path(forResource: vedio, ofType: nil){
                url = URL(fileURLWithPath: path)
            //网络连接尝试
            }else{
                url = URL(string: vedio)
            }
        }
        //url为nil, 返回nil
        guard let currentUrl = url else { return temp }
        
        let asset = AVURLAsset(url: currentUrl)
        let imageGen = AVAssetImageGenerator(asset: asset)
        imageGen.appliesPreferredTrackTransform = true
        //设置这2个属性,就会获取精确时间,从而获取到具体帧;若不设置,会在一定范围从缓存获取,而优化内存
        if index > 0 {
            imageGen.requestedTimeToleranceAfter = CMTime.zero
            imageGen.requestedTimeToleranceBefore = CMTime.zero
        }
        let cmTime = CMTime(seconds: Double(index), preferredTimescale: 600)
        var time : CMTime = CMTime()
        if let cgImage = try? imageGen.copyCGImage(at: cmTime, actualTime: &time){
            let image = UIImage(cgImage: cgImage)
            temp = image
        }
        return temp
    }
    
    /// 通过颜色获取图片
    /// - Parameter color: 颜色
    /// - Parameter size: 图片大小
    static func colorImage(_ color : UIColor , size : CGSize = CGSize(width: 1, height: 1)) -> UIImage?{
        var temp : UIImage?
        if size == CGSize.zero {
            return temp
        }
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let ctx = UIGraphicsGetCurrentContext(){
            ctx.setFillColor(color.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            temp = img
        }
        UIGraphicsEndImageContext()
        return temp
    }
    
    /// 获取渐变色图片 
    ///
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 渐变位置数组. (0~1.0之间 , 不设置默认按照系统样式)
    ///   - direction: 渐变方向. (默认从左到右)
    ///   - size: 图片大小
    /// - Returns: 图片对象
    static func gradualImage(_ colors : [UIColor] , locations : [CGFloat]? = nil ,from direction : HKGradualDirection = .left , size : CGSize) -> UIImage?{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if let layer = view.addGradual(colors, locations: locations, from: direction, frame: view.frame) {
            var tempImg : UIImage?
            UIGraphicsBeginImageContext(size)
            if let ctx = UIGraphicsGetCurrentContext(){
                layer.render(in:ctx)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                tempImg = img
            }
            UIGraphicsEndImageContext()
            return tempImg
        }
        return nil
    }
    
    
    /// 剪裁图片
    /// - Parameter shape: 剪裁形状
    /// - Parameter borderColor: 边框颜色
    /// - Parameter borderWidth: 边框宽度
    func clip(_ shape : HKImageClipShape = .circle , borderColor : UIColor , borderWidth : CGFloat) -> UIImage {
        var temp : UIImage = self
        if borderWidth <= 0 {
            return temp
        }
        
        let size = CGSize(width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(size)
        var path : UIBezierPath?
        var clipPath : UIBezierPath?
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let clipRect = CGRect(x: borderWidth, y: borderWidth, width: size.width - 2 * borderWidth, height: size.height - 2 * borderWidth)
        switch shape {
        case .circle:
            path = UIBezierPath(ovalIn: rect)
            clipPath = UIBezierPath(ovalIn: clipRect)
        case .square:
            path = UIBezierPath(rect: rect)
            clipPath = UIBezierPath(rect: clipRect)
        //default:break
        }
        //画大背景
        guard let p = path , let cp = clipPath else { return temp }
        borderColor.setFill()
        p.fill()
        
        //剪掉
        cp.addClip()
        //绘制
        self.draw(in: clipRect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        temp = img ?? self
        
        return temp
    }
}
