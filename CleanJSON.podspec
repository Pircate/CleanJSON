
Pod::Spec.new do |s|
  s.name             = 'CleanJSON'
  s.version          = '0.9.4'
  s.summary          = 'Swift JSON decoder for Codable.'
  s.homepage         = 'https://github.com/Pircate/CleanJSON'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pircate' => 'gao497868860@163.com' }
  s.source           = { :git => 'https://github.com/Pircate/CleanJSON.git', :tag => s.version.to_s }
  s.default_subspec  = "source"
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.swift_versions = ['4.2', '5.0']

  s.subspec 'source' do |source|
    source.source_files = 'CleanJSON/Classes/**/*'
  end

  s.subspec 'binary' do |binary|
    s.static_framework = true
    binary.source_files = "Carthage/Build/iOS/Static/CleanJSON.framework/Headers/*.h"
    binary.ios.vendored_frameworks = "Carthage/Build/iOS/Static/CleanJSON.framework"
    binary.ios.public_header_files = "Carthage/Build/iOS/Static/CleanJSON.framework/Headers/*.h"
  end

end
