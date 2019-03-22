#
# Be sure to run `pod lib lint BlackNest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BlackNest'
  s.version          = '1.0.1'
  s.summary          = 'Reusable Testing'

  s.description      = <<-DESC
  Pain-free and reusable testing by using a small DSL.
  DESC

  s.homepage         = 'https://github.com/symentis/BlackNest'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { "symentis GmbH" => "github@symentis.com" }
  s.source           = { :git => 'https://github.com/symentis/BlackNest.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '4.0'
  s.source_files = 'BlackNest/*.swift'
  s.frameworks = 'XCTest'
end
