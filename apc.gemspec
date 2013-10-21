Gem::Specification.new do |s|
  s.name      = 'apc'
  s.version   = '0.0.12'
  s.date      = '2013-10-21'
  s.summary   = 'Control an APC PDU by SNMP'
  s.authors   = '["Paul Thomas"]'
  s.email     = 'pthomas@dyn.com'
  s.files     = ["lib/apc.rb", "lib/mibs/PowerNet-MIB.yaml", "lib/mibs/RFC1213-MIB.yaml"]
  s.homepage  = 'http://rubygems.org/gems/apc'
  s.license   = 'Apache 2.0'
  s.add_dependency('snmp', '= 1.1.1')
end
