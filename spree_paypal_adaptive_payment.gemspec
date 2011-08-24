Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_paypal_adaptive_payment'
  s.version     = '0.1.0'
  s.summary     = 'Add PayPal Adaptive Payments to Spree store'
  s.homepage    = 'https://github.com/jpablobr/spree_paypal_adaptive_payment'
  s.author      = 'Jose Pablo Barrantes'
  s.email       = 'xjpalobrx@gmail.com'
  s.required_ruby_version = '>= 1.8.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.has_rdoc      = false

  s.add_dependency('spree_core', '>=0.40.3')
end
