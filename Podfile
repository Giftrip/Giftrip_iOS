platform :ios, '13.0'
inhibit_all_warnings!

def test_pods
  pod 'Stubber'
  pod 'Quick'
  pod 'Nimble'
end

target 'Giftrip' do
  use_frameworks!
  
  # Architecture
  pod 'ReactorKit'
  
  # UI
  pod 'SnapKit'
  pod 'SwiftMessages'
  pod 'GoogleMaps'
  pod 'DrawerView'
  
  # Rx
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxDataSources'
  pod 'RxViewController'
  pod 'RxOptional'
  pod 'RxGesture'
  pod 'RxFlow'
  
  # DB
  pod 'RealmSwift'
  
  # Network
  pod 'Moya/RxSwift'
  pod 'Kingfisher'
  
  # Tool
  pod 'SwiftLint'
  pod 'R.swift'
  pod 'Then'
  pod 'ReusableKit/RxSwift'
  
  # Security
  pod 'KeychainAccess'
  pod 'CryptoSwift'
  
  target 'GiftripTests' do
    inherit! :search_paths
    test_pods
  end
  
  target 'GiftripUITests' do
    test_pods
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
