# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'uinit/sig/version'

Gem::Specification.new do |spec|
  spec.name = 'uinit-sig'
  spec.version = Uinit::Sig::VERSION
  spec.authors = ['Kimoja']
  spec.email = ['joakim.carrilho@cheerz.com']

  spec.summary = 'Signed methods'
  spec.description = 'Signed methods'
  spec.homepage = 'https://github.com/Kimoja/uinit-sig'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.1'
  spec.files = Dir['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'uinit-sig.gemspec', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.executables = []

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['source_code_uri'] = 'https://github.com/Kimoja/uinit-sig'
  spec.metadata['changelog_uri'] = 'https://github.com/Kimoja/uinit-sig/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/Kimoja/uinit-sig/issues'

  spec.add_runtime_dependency 'zeitwerk', '~> 2.6'

  spec.add_dependency 'uinit-memoizable', '~> 0.1.0'
  spec.add_dependency 'uinit-structure', '~> 0.1.0'
  spec.add_dependency 'uinit-type', '~> 0.1.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
