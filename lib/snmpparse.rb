#!/usr/local/bin/ruby

## SNMP::MIB.open  --> Module::Class.method
## ^      ^     ^
## Module Class Def (Method)
##
## Alternatively, you can "include SNMP" and omit 'SNMP::'

require 'snmp'
include SNMP

if MIB.import_supported? then
        puts "Import is supported.  Available MIBs include:"

        mib_list = MIB.list_imported
        puts mib_list

else
        puts "Import is NOT support"
        exit
end

puts "-------------------------------------------"
puts "Importing MIB..."

MIB.import_module("./409.dump", ".")

puts "Done."
