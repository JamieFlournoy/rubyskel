#!/usr/bin/env ruby

libdir = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "bundler/setup"
require 'rubyskel'
Rubyskel.run ARGV
