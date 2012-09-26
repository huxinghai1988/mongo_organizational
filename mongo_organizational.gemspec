# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "mongo_organizational"
  gem.version       = "0.0.6"
  gem.authors       = ["lshgood"]
  gem.email         = ["liushaohong159@163.com"]
  gem.description   = "Replace mongo database , Rewrite mongo connection session."
  gem.summary       = "Replace mongo database"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "mongoid", '~> 3.0.2'
end
