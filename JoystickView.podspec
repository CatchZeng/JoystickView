Pod::Spec.new do |s|
  s.name             = 'JoystickView'
  s.version          = '1.0.0'
  s.swift_version    = '4.2'
  s.summary          = 'iOS Swift Joystick View.'
  s.description      = 'Support around,vertical,horizontal directions Joystick View for iOS.'
  s.homepage         = 'https://github.com/CatchZeng/JoystickView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CatchZeng' => '891793848@qq.com' }
  s.source           = { :git => 'https://github.com/CatchZeng/JoystickView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'JoystickView/Classes/**/*'
end
