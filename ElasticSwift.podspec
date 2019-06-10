Pod::Spec.new do |s|

  s.name         = "ElasticSwift"
  s.version      = "1.0.0-alpha.5"
  s.summary      = "Elasticsearch client in native swift"
  s.description  = "ElasticSwift allows you to bring prower of elasticsearch in your apps on macOS, iOS, tvOS, watchOS and linux."

  s.homepage     = "http://github.com/pksprojects/ElasticSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "pksprojects" => "support@pksprojects.com" }
  s.source       = { :git => "https://github.com/pksprojects/ElasticSwift.git", :tag => "v#{s.version}" }
  
  s.ios.deployment_target = "12.2"
  s.osx.deployment_target = "10.14.4"
  s.watchos.deployment_target = "5.2"
  s.tvos.deployment_target = "12.2"
  
  s.source_files = 'Sources/ElasticSwift/**/*.swift'

end
