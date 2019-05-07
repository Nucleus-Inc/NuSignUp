#
# Be sure to run `pod lib lint NuSignUp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NuSignUp'
  s.version          = '1.0.4'
  s.summary          = 'The basic configuration of a sign up flow, it is like a pattern. ;)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"Most applications need a sign up flow, so thinking about it I created this project with all basic configurations to turn the process faster and easy to customize. So if you are looking a way to make the sign up flow of your application and do not know how to start, this is the project you are looking for."
                       DESC

  s.homepage         = 'https://github.com/Nucleus-Inc/NuSignUp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'José Lucas' => 'chagasjoselucas@gmail.com' }
  s.source           = { :git => 'https://github.com/Nucleus-Inc/NuSignUp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'NuSignUp/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NuSignUp' => ['NuSignUp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'Regex', '0.3.0'
  #s.dependency 'InputMask', '~> 3.4'

end
