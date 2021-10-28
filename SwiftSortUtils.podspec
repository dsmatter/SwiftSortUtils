#
# Be sure to run `pod lib lint SwiftSortUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftSortUtils"
  s.version          = "0.4.0"
  s.summary          = "Useful functions and extensions for sorting in Swift"

  s.description      = <<-DESC
                       This library takes a shot at making sorting in Swift more pleasant.
                       It also allows you to reuse your old NSSortDescriptor instances in Swift.
                       DESC

  s.homepage         = "https://github.com/dsmatter/SwiftSortUtils"
  s.license          = 'MIT'
  s.author           = { "Daniel Strittmatter" => "daniel@smattr.de" }
  s.source           = { :git => "https://github.com/dsmatter/SwiftSortUtils.git", :tag => s.version.to_s }

  s.platform         = :ios, '9.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true

  s.source_files     = 'Pod/Classes/**/*'
end
