#
#  Be sure to run `pod spec lint HKBaseComponent.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  #******************** 库信息 *********************
  # 库info
  s.name         = "HKBaseComponent"
  s.version      = "1.0.0"
  s.summary      = "haiker 的 iOS基础库"
  s.description  = <<-DESC
                      基础库, 存放上层库共用的东西
                   DESC
  s.homepage     = "https://github.com/haikerapples/HKBaseComponent.git"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  # 源码地址
  s.source       = { :git => "https://github.com/haikerapples/HKBaseComponent.git", :tag => s.version.to_s }

  # 库设置
  s.platform     = :ios
  s.platform     = :ios, "9.0"
  # 多平台写法
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  
  s.requires_arc = true
  s.swift_version = '5.0.0'
  s.static_framework = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  # 文件路径
  s.source_files  = "HKBaseComponent/**/*"
  
  # 组件
  s.subspec 'HKComponent' do |sub|
      sub.source_files = 'HKBaseComponent/HKComponent/**/*'
  end
  
  # 分类
  s.subspec 'HKExtension' do |sub|
      sub.source_files = 'HKBaseComponent/HKExtension/**/*'
  end
  # s.public_header_files = "Classes/**/*.h"

  #依赖 系统库
  s.frameworks = "UIKit", "Foundation"
  
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  #依赖 三方库
  # s.dependency "JSONKit", "~> 1.4"
  
  
  #******************** 资源文件 ********************
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.resource_bundles = {
  #   'HKBaseComponent' => ['HKBaseComponent/Assets/*.png']
  # }

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  
  
  #******************** 作者信息 ********************
  s.author             = { "haiker" => "876253014@qq.com" }
  # Or just: s.author    = "haiker"
  # s.authors            = { "haiker" => "876253014@qq.com" }
  # s.social_media_url   = "https://twitter.com/haiker"
  
  # 专利声明
  s.license      = { :type => "MIT", :file => "LICENSE" }
  # s.license      = "MIT"

end

