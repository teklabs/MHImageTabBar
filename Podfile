source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

xcodeproj '/Volumes/WINHD/Repos/MHImageTabBar/MHImageTabBar.xcodeproj'

def common_pods
  pod 'IOStickyHeader'
  pod 'AHKActionSheet', '~> 0.5'
  pod 'AMPopTip', '~> 0.7'
  pod 'MBProgressHUD'
  pod 'FormatterKit'
  pod 'Parse'
  pod 'Bolts'
  pod 'ParseUI'
  pod 'UIImageAFAdditions', :git => 'https://github.com/teklabs/UIImageAFAdditions.git'
  pod 'ParseFacebookUtilsV4'
  pod 'ParseTwitterUtils'
  #pod 'FBSDKCoreKit'
end


target 'MHImageTabBar' do
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