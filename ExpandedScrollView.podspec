Pod::Spec.new do |s|
  s.name        = 'ExpandedScrollView'
  s.version     = '0.1.0'
  s.authors     = { 'CyonLeu' => 'cyonleu@126.com' }
  s.homepage    = 'https://github.com/CyonLeu/FWSideMenu'
  s.summary     = 'basic ExpandedScrollView,Special add 3D side , blurred content effect.'
  s.source      = { :git => 'https://github.com/CyonLeu/ExpandedScrollView.git',
                    :tag => s.version.to_s }
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.platform = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'ExpandedScrollView/Classes/*'
  # s.public_header_files = 'ExpandedScrollView/Classes/*.{h'

  s.ios.deployment_target = '7.0'
  s.ios.frameworks = 'QuartzCore'
s.dependency 'pod 'Masonry', '0.6.3'
end
