Pod::Spec.new do |s|
  s.name         = "IsaacsIOSLibrary"
  s.version      = "1.0"
  s.summary      = "A toolkit to help with API interfaceing."
  s.homepage     = "https://github.com/jlorich/APIKit.git"
  s.license      = "MIT"
  s.author       = { "Isaac Paul" => "izackp@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "5.1"
  s.source       = { :git => "https://github.com/izackp/Isaacs-IOS-Library", :tag => s.version.to_s }
  s.source_files  = "IsaacsIOSLibrary", "IsaacsIOSLibrary/**/*.{h,m}"
  s.requires_arc = true

end
