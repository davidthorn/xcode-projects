
Pod::Spec.new do |s|

s.name         = "MapController"
s.version      = "0.1.0"
s.summary      = "A summary of your framework"
s.swift_version = '4.2'
s.description  = <<-DESC
A description about your framework
DESC

s.homepage     = "https://github.com/davidthorn/MapController.git"

s.license      = { :type => "MIT" }

s.author       = { "David Thorn" => "david.thorn221278@googlemail.com" }

s.ios.deployment_target = "9.3"

s.source       = { :git => "https://github.com/davidthorn/MapController.git", :tag => "#{s.version}" }

s.source_files  = "MapController/Classes/**/*.{swift}"
s.resources = "MapController/Assets/**/*.{storyboard, xibs}"

s.dependency 'TabBarController'
s.dependency 'MapItemForm'
end
