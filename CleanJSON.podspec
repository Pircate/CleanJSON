
Pod::Spec.new do |s|
  s.name             = 'CleanJSON'
  s.version          = '1.0.9'
  s.summary          = 'Swift JSON decoder for Codable.'
  s.homepage         = 'https://github.com/Pircate/CleanJSON'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pircate' => 'gao497868860@163.com' }
  s.source           = { :git => 'https://github.com/Pircate/CleanJSON.git', :tag => s.version.to_s }
  s.source_files     = 'Sources/CleanJSON/**/*'
  
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.swift_versions = ['5.2']
end
