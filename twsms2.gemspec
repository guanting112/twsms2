# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twsms2/version'

Gem::Specification.new do |spec|
  spec.name          = "twsms2"
  spec.version       = Twsms2::VERSION
  spec.authors       = ["Guanting Chen"]
  spec.email         = ["cgt886@gmail.com"]
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY
  spec.summary       = %q{2016 新版 台灣簡訊 TwSMS API ( 純 Ruby / Rails 專案適用 )}
  spec.description   = %q{2016 新版 台灣簡訊 TwSMS API ( 純 Ruby / Rails 專案適用 )}
  spec.homepage      = "https://github.com/guanting112/twsms2"
  spec.required_ruby_version = '~> 2'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency 'webmock', '~> 1.18'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
