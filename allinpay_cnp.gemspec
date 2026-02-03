# frozen_string_literal: true

require_relative 'lib/allinpay_cnp/version'

Gem::Specification.new do |spec|
  spec.name          = 'allinpay_cnp'
  spec.version       = AllinpayCnp::VERSION
  spec.authors       = ['DrinE']
  spec.email         = ['drine.liu@gmail.com']

  spec.summary       = 'Ruby SDK for Allinpay CNP cross-border payment gateway'
  spec.description   = '通联支付 CNP 跨境信用卡收单 Ruby SDK'
  spec.homepage      = 'https://github.com/CoolDrinELiu/allinpay'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.files         = Dir['lib/**/*', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 1.0', '< 3.0'
end
