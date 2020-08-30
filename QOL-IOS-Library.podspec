Pod::Spec.new do |s|
  s.name         = "QOL-IOS-Library"
  s.version      = "1.1"
  s.summary      = "A toolkit to help with API interfaceing."
  s.homepage     = "https://github.com/izackp/QOL-IOS-Library.git"
  s.license      = "MIT"
  s.author       = { "Isaac Paul" => "izackp@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "5.1"
  s.source       = { :git => "https://github.com/izackp/Isaacs-IOS-Library", :tag => s.version.to_s }
  s.source_files  = "QOL-IOS-Library", "QOL-IOS-Library/**/*.{h,m,swift}"
  s.requires_arc = true

end
