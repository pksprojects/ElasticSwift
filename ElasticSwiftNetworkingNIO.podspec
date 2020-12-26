Pod::Spec.new do |s|

    s.name         = "ElasticSwiftNetworkingNIO"
    s.version      = "1.0.0-beta.1"
    s.summary      = "Networking layer of ElasticSwift"
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
    
    s.source_files = 'Sources/ElasticSwiftNetworkingNIO/**/*.swift'
  
    s.dependency 'ElasticSwiftCore', "#{s.version}"
    s.dependency 'SwiftNIO', '~> 2.22'
    s.dependency 'SwiftNIOHTTP1', '~> 2.22'
    s.dependency 'SwiftNIOTLS', '~> 2.22'
    s.dependency 'SwiftNIOConcurrencyHelpers', '~> 2.22'
    s.dependency 'SwiftNIOFoundationCompat', '~> 2.22'
    s.dependency 'SwiftNIOSSL', '~> 2.9'
    s.dependency 'SwiftNIOTransportServices', '~> 1.9'
    s.dependency 'Logging', '~> 1.4'
  
end

