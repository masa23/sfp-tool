#!/usr/bin/env ruby

require 'pp'
require './ruby-libsfp/lib/sfp/eeprom.rb'
require './ruby-libsfp/lib/sfp/rw.rb'

rw = SFP::RW.new

sfp = SFP::EEPROM.new(rw.read)

if sfp.vendor_name == "Arista Networks"
  puts "This is an Arista SFP"
else
  puts "This is not an Arista SFP"
  puts "Vendor Name: #{sfp.vendor_name}"
  exit 1
end

sfp.vendor_name = "Intel Corp"
sfp.vendor_oui = [0, 27, 33]
#sfp.transciever = [:PASSIVE_CABLE]

# 書き込み
rw.write(sfp.to_hex)
puts "Write done"

# 読み込み
sfp2 = SFP::EEPROM.new(rw.read)

puts "Vendor Name: #{sfp2.vendor_name}"

if sfp.to_hex == sfp2.to_hex
  puts "Write Verify OK"
else
  puts "Write Verify NG"
  exit 1
end
