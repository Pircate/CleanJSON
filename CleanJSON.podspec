
Pod::Spec.new do |spec|

  spec.name         = "CleanJSON"
  spec.version      = "0.1.0"
  spec.summary      = "Custom JSON decoder for Decodable."
  spec.homepage     = "https://github.com/Pircate/CleanJSON"
  spec.license      = "MIT"
  spec.author       = { "Pircate" => "gao497868860@163.com" }
  spec.source       = { :git => "https://github.com/Pircate/CleanJSON.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/**/*"
  spec.ios.deployment_target = '9.0'
  spec.swift_version = '4.0'

end
