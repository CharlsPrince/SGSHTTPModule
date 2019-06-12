
Pod::Spec.new do |s|
  s.name      = 'SGSHTTPModule'
  s.version   = '0.5.2'
  s.summary   = '基于 AFNetworking 封装的 HTTP 请求组件'

  s.homepage  = 'https://github.com/CharlsPrince/SGSHTTPModule'
  s.license   = { :type => 'MIT', :file => 'LICENSE' }
  s.author    = { 'CharlsPrince' => '961629701@qq.com' }
  s.source    = { :git => 'https://github.com/CharlsPrince/SGSHTTPModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SGSHTTPModule/Classes/**/*'
  s.public_header_files = 'SGSHTTPModule/Classes/**/*.{h}'
  
  s.dependency 'AFNetworking', '~> 3.1.0'
end
