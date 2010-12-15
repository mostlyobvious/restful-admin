spec = Gem::Specification.new do |s|
  s.name = "restful_admin"
  s.summary = "RestfulAdmin: administration panel application."
  s.description = "RestfulAdmin. Drop-in and go, have some rest!"
  s.files =  Dir["[A-Z]*", "lib/**/*", "app/**/*", "config/**/*", "public/**/*"]
  s.version = "0.0.2"
  s.author = "Paweł Pacana"
  s.email = "pawel.pacana@gmail.com"
  s.add_dependency "will_paginate", "~> 3.0pre2"
  s.add_dependency "auto_excerpt"
  s.add_dependency "simple_form"
  s.add_dependency "responders"
  s.add_dependency "meta_search"
end

