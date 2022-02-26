Pod::Spec.new do |s|
  s.name        = "RCPageControl"
  s.version     = "0.1.2"
  s.summary     = "Yet another page control for iOS, with awesome animation powered by facebook pop library."
  s.homepage    = "https://github.com/looping/RCPageControl"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  s.authors     = { "Looping" => "www.looping@gmail.com" }

  s.platform    = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source      = { :git => "https://github.com/looping/RCPageControl.git", :tag => s.version.to_s }
  s.source_files = 'RCPageControl'
  s.public_header_files = 'RCPageControl/*.h'

  s.requires_arc = true

  s.dependency 'pop'
end
