require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path '../rw_connector.rb', __FILE__

run RwConnector
