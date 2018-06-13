Gem::Specification.new do |s|
  s.name = 'logstash-output-azuresearch'
  s.version    =  File.read("VERSION").strip
  s.authors = ["Dwight Spencer", "Yoichi Kawasaki"]
  s.email = "dspencer@computekindustries.com"
  s.summary = %q{logstash output plugin to store events into Azure Search}
  s.description = s.summary
  s.homepage = "http://github.com/denzuko/logstash-output-azuresearch"
  s.licenses = ["Apache License (2.0)"]
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT', 'VERSION']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "rest-client",              "~> 1.8.0"
  s.add_runtime_dependency "logstash-core",            "~> 5.0.0"
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "logstash-codec-plain"      "~> 3.0.3"
  s.add_development_dependency "logstash-devutils"

end
