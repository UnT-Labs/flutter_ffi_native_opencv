#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint native_opencv.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_opencv'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'


  # telling CocoaPods not to remove framework
  s.preserve_paths = 'opencv2.framework' 

  # telling linker to include opencv2 framework
  s.xcconfig = { 
    'OTHER_LDFLAGS' => '-framework opencv2',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
  }

  # including OpenCV framework
  s.vendored_frameworks = 'opencv2.framework' 

  # including native framework
  s.frameworks = 'AVFoundation'

  # including C++ library
  s.library = 'c++'

  # module_map is needed so this module can be used as a framework
  s.module_map = 'native_opencv.modulemap'
end
