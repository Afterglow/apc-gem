Gem::Specification.new do |s|
  s.name      = 'apc'
  s.version   = '0.0.6'
  s.date      = '2013-10-07'
  s.summary   = 'Control an APC PDU by SNMP'
  s.authors   = '["Paul Thomas"]'
  s.email     = 'pthomas@dyn.com'
  s.files     = ["lib/apc.rb"]
  s.homepage  = 'http://rubygems.org/gems/apc'
  s.license   = 'Apache 2.0'
  s.add_dependency('snmp', '= 1.1.1')
end
