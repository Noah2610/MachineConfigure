lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib)  unless $LOAD_PATH.include?(lib)
require 'machine_configure/meta'
github_url = 'https://github.com/Noah2610/MachineConfigure'

Gem::Specification.new do |spec|
  spec.name        = MachineConfigure::GEM_NAME
  spec.version     = MachineConfigure::VERSION
  spec.authors     = ['Noah Rosenzweig']
  spec.email       = ['rosenzweig.noah@gmail.com']
  spec.summary     = 'Manage your docker-machines\' configuration files.'
  spec.description = <<-END
    This gem can import or export the necessary configuration files
    for your docker-machine configuration.
    Use it to share your machine instances with others.
  END
  spec.homepage    = github_url
  spec.license     = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split(?\x0).reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',  '~> 1.16'
  #spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'rdoc'

  spec.add_dependency 'rubyzip', '~> 1.2'
end
