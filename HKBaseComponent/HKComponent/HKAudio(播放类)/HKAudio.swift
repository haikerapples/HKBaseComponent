//
//  HKAudio.swift
//  swiftProject
//
//  Created by MacBook on 2019/8/27.
//  Copyright © 2019 haiker. All rights reserved.
//

import UIKit
import AVKit

//声音枚举
enum HKAudioSoundType {
    case none   //无声音
    case camera //系统相机声音
    
    case custom(_ fileName : String) //自定义声音
    
    
    /// 声音ID
    var soundId : SystemSoundID{
        var temp : SystemSoundID = 0
        
        switch self {
        case .none:
            temp = 0
        case .camera:
            temp = 1108
           
        case let .custom(t):
            if let path = Bundle.main.path(forResource: t, ofType: nil){
                let fileUrl = URL(fileURLWithPath: path)
                var soundId : SystemSoundID = 0
                AudioServicesCreateSystemSoundID(fileUrl as CFURL, &soundId)
                temp = soundId
            }
            
//        default:
//            break
        }
        
        return temp
    }
    
    
    /// 播放声音
    /// - Parameter isShake: 是否需要震动
    func play(_ isShake : Bool = false) -> Void {
        //无音频
        if self.soundId == 0 {
            return
        }
        
        //播放声音
        let soundId = self.soundId
        if isShake {
            AudioServicesPlayAlertSoundWithCompletion(soundId, {
                AudioServicesDisposeSystemSoundID(soundId)
            })
        }else{
            AudioServicesPlaySystemSoundWithCompletion(soundId) {
                AudioServicesDisposeSystemSoundID(soundId)
            }
        }
    }
    
}

//播放类
class HKAudio: NSObject {

    static let shared = HKAudio()
}

//方法
extension HKAudio{
    /// 播放视频
    /// - Parameter url: url路径
    /// - Parameter presentViewController: 由谁弹出. nil时, 默认当前控制器
    func play(_ url : String , presentViewController : UIViewController){
       if let url = URL(string: url){
           let player = AVPlayer(url: url)
        
           let avVC = AVPlayerViewController()
           avVC.player = player
           let presentVC = presentViewController
           //弹出
           presentVC.present(avVC, animated: true, completion: {
            
           })
       }
    }
    
    
}
