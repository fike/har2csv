
Gem::Specification.new do |spec|
  spec.name          = "har2csv"
  spec.version       = '0.0.1 '
  spec.authors       = ["Fernando Ike"]
  spec.email         = ["fike@midstorm.org"]

  spec.summary       = %q{har2csv}
  spec.description   = %q{A simple tool to export some header to csv file.}
  spec.homepage      = "https://github.com/fike/har2csv"
  spec.license       = "MIT"

  spec.add_runtime_dependency "addressable", "~>2.4"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
#  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         = ["Rakefile", "bin/har2csv"]
  spec.executables   = ["har2csv"]
  spec.require_paths = ["lib"]
  spec.test_files    = ["test/test_har2csv.rb"]



end
