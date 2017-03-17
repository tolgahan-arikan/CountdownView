Pod::Spec.new do |s|
  s.name             = 'CountdownView'
  s.version          = '0.1.1'
  s.summary          = 'Simple countdown view with custom animations'

  s.description      = <<-DESC
  Simple countdown view for showing the remaining time with options like spinning and in/out animations.
                       DESC

  s.homepage         = 'https://github.com/tolgaarikan/CountdownView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tolgahan Arikan' => 'tolgaarikann@gmail.com' }
  s.source           = { :git => 'https://github.com/tolgaarikan/CountdownView.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.source_files = 'CountdownView/Classes/**/*'
  s.requires_arc = true
  s.frameworks = 'UIKit'

  s.social_media_url = 'https://twitter.com/tolgahanarikan'

end
