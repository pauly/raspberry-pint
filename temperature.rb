#!/usr/bin/ruby

# depracated, renamed to raspbrewery

require_relative 'OneWire.rb'
wire = OneWire.new :logDir => '/home/pi/'
wire.writeLog
puts wire.graph 
