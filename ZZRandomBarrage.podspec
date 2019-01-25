#
#  Be sure to run `pod spec lint ZZRandomBarrage.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZZRandomBarrage"
  s.version      = "0.0.4"
  s.summary      = "ZZ Series - Random Barrage"
  s.description  = "ZZ Series - a view for random barrage"
  s.homepage     = "https://github.com/delete-x/ZZRandomBarrage"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  #Ren Qiang Bin 
  s.author       = { "delete-x" => "coder_rqb@163.com" } 
  s.platform     = :ios, "7.0"                  
  s.source       = { :git => "https://github.com/delete-x/ZZRandomBarrage.git", :tag => "0.0.4" }
  s.source_files  =  'ZZRandomBarrage/**/*'
  s.requires_arc = true

end
