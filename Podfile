#platform :ios, '9.0'

xcodeproj '/Volumes/WINHD/Repos/MHImageTabBar/MHImageTabBar.xcodeproj'

#def common_pods
    
    
target 'MHImageTabBar' do

use_frameworks!
  pod 'Parse'
  pod 'ParseUI'
  #pod 'Bolts'
  #pod 'Parse', '~> 1.7.5'
  #pod 'ParseFacebookUtils', '~> 1.7.5'
  pod 'ParseFacebookUtilsV4'
  pod 'ParseTwitterUtils'
  pod 'FBSDKCoreKit'
  pod 'TwitterKit'
  pod 'TwitterCore'

#pod 'ParseCrashReporting', '~> 1.7.5'


  # Workaround for the unknown crashes Bolts (https://github.com/BoltsFramework/Bolts-iOS/issues/102)
  #pod 'Bolts', :git => https://github.com/teklabs/Bolts-iOS.git
  #pod 'ParseUI', '1.1.4'
  pod 'MBProgressHUD'
  pod 'FormatterKit'
  
  pod 'UIImageAFAdditions', :git => 'https://github.com/teklabs/UIImageAFAdditions.git'



  pod 'Synchronized'

  
  pod 'IOStickyHeader'
  pod 'AHKActionSheet', '~> 0.5'
  pod 'AMPopTip', '~> 0.7'
  pod 'ActionButton', git: 'https://github.com/teklabs/ActionButton.git', branch: 'master'
  pod 'DynamicButton', '~> 1.2.0'
  pod 'PathMenu', git: 'https://github.com/teklabs/PathMenu.git', branch: 'master'
end


#target 'MHImageTabBar' do
#  use_frameworks!
#  common_pods
#end

#inhibit_all_warnings!
#use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end