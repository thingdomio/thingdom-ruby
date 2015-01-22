require '.\lib\thingdom\version'

Gem::Specification.new do |gem|

  gem.authors       = ["Joel Levandoski"]
  gem.email         = ["joel.levandoski@gmail.com"]

  gem.description   = "The official Ruby gem for the Thingdom.io API."

  gem.summary       = "Thingdom"
  gem.homepage      = "https://github.com/thingdomio/thingdom-ruby"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split("\n")
  gem.name          = 'thingdom'
  gem.date          = '2015-01-07'
  gem.require_paths = ["lib"]
  gem.version       = Thingdom::VERSION

end