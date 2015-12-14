source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

def common_pods
  pod 'IOStickyHeader'
end


target 'MHImageTabBar'
  common_pods
end

inhibit_all_warnings!
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'YES'
    end
  end
end