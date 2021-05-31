platform :ios, '13.0'
inhibit_all_warnings!

target 'Giftrip' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'
  
  # UI
  pod 'SnapKit'
  pod 'RxFlow'
  pod 'SwiftMessages'
  pod 'NMapsMap'
  
  # Rx
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxDataSources'
  pod 'RxViewController'
  pod 'RxOptional'
  pod 'RxGesture'
  
  # DB
  pod 'RealmSwift'
  
  # Network
  pod 'Moya/RxSwift'
  pod 'Kingfisher'
  
  # Tool
  pod 'SwiftLint'
  pod 'R.swift'
  pod 'Then'
  pod 'Swinject'
  
  # Security
  pod 'KeychainAccess'
  pod 'CryptoSwift'

  target 'GiftripTests' do
    inherit! :complete
    pod 'Stubber'
    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
