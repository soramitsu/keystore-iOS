#
# Be sure to run `pod lib lint SoraKeystore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoraKeystore'
  s.version          = '1.0.2'
  s.summary          = 'A library to wrap logic related to keychain and user defaults.'

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'GPL 3.0', :file => 'LICENSE' }
  s.author           = { 'Soramitsu' => 'bot@soramitsu.co.jp' }
  s.source           = { :git => 'https://github.com/soramitsu/keystore-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.swift_version = '5.0'

  s.source_files = 'SoraKeystore/Classes/**/*'

#  s.test_spec do |ts|
#      ts.source_files = 'Tests/**/*'
#  end

end
