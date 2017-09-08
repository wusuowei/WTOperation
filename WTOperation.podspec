Pod::Spec.new do |s|
  s.name             = 'WTOperation'
  s.version          = '0.1.0'
  s.summary          = 'WTOperation让你更简单的使用NSOperation创建队列任务.'

  s.description      = '你只需要继承WTOperation，重载一个实现就能使用NSOperationQueue进行管理你的并发任务，不需要关心NSOperation的各种状态'

  s.homepage         = 'https://github.com/wusuowei/WTOperation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wentianen' => '1206860151@qq.com' }
  s.source           = { :git => 'https://github.com/wusuowei/WTOperation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WTOperation/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WTOperation' => ['WTOperation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
