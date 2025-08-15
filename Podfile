# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
target 'Bazaar Ghar' do
 # Comment the next line if you don't want to use dynamic frameworks
 use_frameworks!
 # Pods for Bazaar Ghar
pod 'SwiftLog'
  pod 'SwiftHSVColorPicker'
  pod 'Result', '~> 5.0'



 
  pod 'DropDown', '2.3.13'
  # pod 'SDWebImage', '5.0'
#  pod 'CircleColorPicker', '~> 1.0.0'
  pod 'IQKeyboardManagerSwift'
  pod 'PhoneNumberKit', '~> 3.6.0'
  pod 'Moya'
  pod 'JGProgressHUD'
  pod 'R.swift', '~> 6.1.0'
  # For gif images
  pod 'SwiftyGif'
  # For drop down menu
#  pod 'DropDown'

  pod 'TagListView', '~> 1.0'
  pod 'Presentr'

  pod 'Cosmos'
  pod 'FirebaseCore'
  pod 'FirebaseFirestore'
  pod 'GoogleSignIn'
  pod 'Toast-Swift'
  pod 'Socket.IO-Client-Swift'
  pod 'Starscream'
pod 'WCCircularFloatingActionMenu'
  pod 'FirebaseAuth'
#  pod 'SignalRSwift'
  pod 'SwiftyJSON'
  pod 'SwiftSignalRClient', '0.9.0'
  
pod 'Alamofire'
pod 'AZTabBar'
pod 'Kingfisher'
pod 'OTPFieldView'
pod 'SwiftFlags'
pod 'UBottomSheet'
pod 'TwilioVideo'
pod 'Firebase/Messaging'
 pod 'FSPagerView'
 pod 'RangeSeekSlider'
 pod 'SideMenu'
pod 'lottie-ios'
pod 'Frames', '4.3.6'

pod 'FBSDKCoreKit'
pod 'FirebaseAnalytics'
pod 'StepperView', '~> 1.6'
 target 'Bazaar GharTests' do
  inherit! :search_paths
  # Pods for testing
 end
 target 'Bazaar GharUITests' do
  # Pods for testing
 end
end
post_install do |pi|
 pi.pods_project.targets.each do |t|
 t.build_configurations.each do |config|
  config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  config.build_settings['ENABLE_BITCODE'] = 'NO'
  config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'

  
 end
 end
end
