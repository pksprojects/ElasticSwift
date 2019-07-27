Pod::Spec.new do |s|

  s.name         = "ElasticSwift"
  s.version      = "1.0.0-alpha.8"
  s.summary      = "Elasticsearch client in native swift"
  s.description  = "ElasticSwift allows you to bring prower of elasticsearch in your apps on macOS, iOS, tvOS, watchOS and linux."

  s.homepage     = "http://github.com/pksprojects/ElasticSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "pksprojects" => "support@pksprojects.com" }
  s.source       = { :git => "https://github.com/pksprojects/ElasticSwift.git", :tag => "v#{s.version}", :submodules => true }
  
  s.swift_version = '5.0'
  s.cocoapods_version = '>=1.6.0'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  
  s.source_files = 'Sources/ElasticSwift/**/*.swift'

  s.dependency 'SwiftNIO', '~> 2.2.0'
  s.dependency 'SwiftNIOHTTP1', '~> 2.2.0'
  s.dependency 'SwiftNIOTLS', '~> 2.2.0'
  s.dependency 'SwiftNIOConcurrencyHelpers', '~> 2.2.0'
  s.dependency 'SwiftNIOFoundationCompat', '~> 2.2.0'
  s.dependency 'SwiftNIOTransportServices', '~> 1.0.3'
  s.dependency 'Logging', '~> 1.1.0'

end
