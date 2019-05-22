#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'background_beolocation_firebase'
  s.version          = '0.0.1'
  s.summary          = 'Firebase adapter for flutter_background_geolocation'
  s.description      = <<-DESC
Automatically uploads recorded locations from flutter_background_geolocation to your Firestore database.
                       DESC
  s.homepage         = 'https://github.com/transistorsoft/flutter_background_geolocation_firebase'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Transistor Software' => 'info@transistorsoft.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Firestore'

  s.ios.deployment_target = '8.0'
end

