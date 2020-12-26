Pod::Spec.new do |s|

    s.name         = "ElasticSwiftCore"
    s.version      = "1.0.0-beta.1"
    s.summary      = "Core module for ElasticSwift"
    s.description  = "ElasticSwift allows you to bring prower of elasticsearch in your apps on macOS, iOS, tvOS, watchOS and linux."
  
    s.homepage     = "http://github.com/pksprojects/ElasticSwift"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "pksprojects" => "support@pksprojects.com" }
    s.source       = { :git => "https://github.com/pksprojects/ElasticSwift.git", :tag => "v#{s.version}", :submodules => true }
    
    s.swift_version = '5.0'
    s.cocoapods_version = '>=1.6.0'
    s.ios.deployment_target = '10.0'
    s.osx.deployment_target = '10.10'
    s.tvos.deployment_target = '10.0'
    
    s.source_files = 'Sources/ElasticSwiftCore/**/*.swift'
  
    s.dependency 'SwiftNIO', '~> 2.22'
    s.dependency 'SwiftNIOHTTP1', '~> 2.22'
    s.dependency 'Logging', '~> 1.4'
  
  end
