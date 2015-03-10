Pod::Spec.new do |s|
  s.name        = "RCPageControl"
  s.version     = "0.1.1"
  s.summary     = "Yet another page control for iOS, with awesome animation powered by facebook pop library."
  s.homepage    = "https://github.com/RidgeCorn/RCPageControl"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  s.authors     = { "Looping" => "www.looping@gmail.com" }

  s.platform    = :ios, '6.0'
  s.ios.deployment_target = '6.0'

  s.source      = { :git => "https://github.com/RidgeCorn/RCPageControl.git", :tag => s.version.to_s }
  s.source_files = 'RCPageControl'
  s.public_header_files = 'RCPageControl/*.h'

  s.requires_arc = true

  s.dependency 'pop'
end
