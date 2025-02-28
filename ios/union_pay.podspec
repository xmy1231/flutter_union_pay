#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint union_pay.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'union_pay'
  s.version          = '1.0.3'
  s.summary          = 'A Flutter plugin for allowing developers to pay with native Android&iOS UnionPay SDKs.'
  s.description      = <<-DESC
  A Flutter plugin for allowing developers to pay with native Android&iOS UnionPay SDKs.
                       DESC
  s.homepage         = 'https://github.com/xmy1231/flutter_union_pay'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'xuj' => 'xujun_05130340@hotmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  s.vendored_libraries = 'Classes/**/*.a'
  s.public_header_files = 'Classes/**/*.h'

  s.frameworks = ['CFNetwork', 'SystemConfiguration']
  s.libraries = 'z','c++'
  s.dependency 'Flutter'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.vendored_frameworks = 'Framework/UPPaymentControlMini.xcframework'
end
