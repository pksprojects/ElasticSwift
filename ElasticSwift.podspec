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
  # s.osx.deployment_target = '10.12'
  # s.tvos.deployment_target = '10.0'
  
  s.default_subspec = "ElasticSwift"

  s.subspec 'ElasticSwift' do |es|
    es.source_files = 'Sources/ElasticSwift/**/*.swift'
    es.dependency 'SwiftNIO'
    es.dependency 'SwiftNIOHTTP1'
    es.dependency 'SwiftNIOTLS'
    es.dependency 'SwiftNIOConcurrencyHelpers'
    es.dependency 'SwiftNIOFoundationCompat'
    es.dependency 'SwiftNIOTransportServices'
    es.dependency 'Logging'
    es.dependency 'ElasticSwift/ElasticSwiftCore'
    es.dependency 'ElasticSwift/ElasticSwiftCodableUtils'
    es.dependency 'ElasticSwift/ElasticSwiftNetworking'
    es.dependency 'ElasticSwift/ElasticSwiftQueryDSL'
  end

  s.subspec 'ElasticSwiftCore' do |core|
    core.source_files = 'Sources/ElasticSwiftCore/**/*.swift'
    core.dependency 'SwiftNIO'
    core.dependency 'SwiftNIOHTTP1'
    core.dependency 'Logging'
  end

  s.subspec 'ElasticSwiftCodableUtils' do |utils|
    utils.source_files = 'Sources/ElasticSwiftCodableUtils/**/*.swift'
  end

  s.subspec 'ElasticSwiftNetworking' do |net|
    net.source_files = 'Sources/ElasticSwiftNetworking/**/*.swift'
    net.dependency 'ElasticSwift/ElasticSwiftCore'
    net.dependency 'SwiftNIO'
    net.dependency 'SwiftNIOHTTP1'
    net.dependency 'SwiftNIOTLS'
    net.dependency 'SwiftNIOConcurrencyHelpers'
    net.dependency 'SwiftNIOFoundationCompat'
    net.dependency 'SwiftNIOTransportServices'
    net.dependency 'Logging'
  end

  s.subspec 'ElasticSwiftQueryDSL' do |dsl|
    dsl.source_files = 'Sources/ElasticSwiftQueryDSL/**/*.swift'
    dsl.dependency 'ElasticSwift/ElasticSwiftCodableUtils'
    dsl.dependency 'ElasticSwift/ElasticSwiftCore'
    dsl.dependency 'Logging'
  end

  s.dependency 'SwiftNIO', '~> 2.2.0'
  s.dependency 'SwiftNIOHTTP1', '~> 2.2.0'
  s.dependency 'SwiftNIOTLS', '~> 2.2.0'
  s.dependency 'SwiftNIOConcurrencyHelpers', '~> 2.2.0'
  s.dependency 'SwiftNIOFoundationCompat', '~> 2.2.0'
  s.dependency 'SwiftNIOTransportServices', '~> 1.0.3'
  s.dependency 'Logging', '~> 1.1.0'

end
