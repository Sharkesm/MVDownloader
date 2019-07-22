#
# Be sure to run `pod lib lint MVDownloader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MVDownloader'
  s.version          = '0.1.2'
  s.summary          = 'Swift library used for downloading images or JSON format files with caching configuration support'
  s.swift_version    = '5.0'
  
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
MVDownloader is a native swift library for making asychronous remote requests to download images or JSON format files from the web.
                       DESC

  s.homepage         = 'https://github.com/Sharkesm/MVDownloader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manase Michael Mhando' => 'sharkesm@gmail.com' }
  s.source           = { :git => 'https://github.com/Sharkesm/MVDownloader.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MVDownloader/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MVDownloader' => ['MVDownloader/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'

end
