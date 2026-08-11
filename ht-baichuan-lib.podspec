Pod::Spec.new do |s|
  s.name         = 'ht-baichuan-lib'
  s.version      = '1.0.0'
  s.summary      = '阿里百川电商套件'
  s.description  = <<-DESC
    阿里百川电商套件
  DESC
  s.homepage     = 'https://github.com/sod5524/ht-baichuan-lib'
  s.license      = { :type => 'MIT', :text => 'MIT License' }
  s.author       = { 'HT' => '' }
  s.source       = { :http => 'https://github.com/sod5524/ht-baichuan-lib.git' }
  s.platform     = :ios, '13.0'

  # ── Frameworks ──────────────────────────────────────────────
  s.vendored_frameworks = Dir.glob('Frameworks/**/*.framework').map { |f| f.sub(%r{^\./}, '') }

  # ── 资源文件 ───────────────────────────────────────────────

  # ── 电商套件外部依赖 ────────────────────────────────────────
  s.dependency 'FMDB'
  s.dependency 'Reachability'
  s.dependency 'SSZipArchive'
  s.dependency 'SDWebImage'
  s.dependency 'Masonry'
  s.dependency 'SocketRocket'

  # ── 系统框架 ────────────────────────────────────────────────
  s.frameworks = [
    'JavaScriptCore',
    'WebKit',
    'CoreTelephony',
    'SystemConfiguration',
    'CoreMotion',
    'CoreLocation',
    'CoreGraphics',
    'CoreText',
    'ImageIO',
    'MobileCoreServices',
    'Accelerate',
    'Security',
    'CFNetwork',
    'AVFoundation',
    'AudioToolbox',
    'Photos',
    'AssetsLibrary',
    'UIKit',
    'Foundation'
  ]

  # ── 系统库 ──────────────────────────────────────────────────
  s.libraries = ['z', 'c++', 'resolv', 'sqlite3', 'icucore', 'stdc++']

  # ── 编译选项 ────────────────────────────────────────────────
  s.pod_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '-ObjC',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'IPHONEOS_DEPLOYMENT_TARGET' => '13.0'
  }

  s.user_target_xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '13.0'
  }
end