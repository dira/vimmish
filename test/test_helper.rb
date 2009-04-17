require 'rubygems'
require 'test/spec'
require 'mocha'
require 'treetop'

require "lib/command"
require "lib/motion"
require "lib/macro_motion"
require "lib/parametric_motion"
require "test/assertions"

Treetop.load "lib/vim"
