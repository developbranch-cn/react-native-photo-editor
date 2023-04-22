require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name         = "RNPhotoEditor"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platforms    = { :ios => "9.0", :osx => "10.13" }

  s.source       = { :git => "https://github.com/developbranch-cn/react-native-photo-editor.git", :tag => "#{s.version}" }
  s.source_files  = "src/**/*.{h,m,swift}"

  s.description  = <<-DESC
                  RNPhotoEditor
                   DESC
  
  s.dependency "React"
  #s.dependency "others"

end
  