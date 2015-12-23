require 'rubygems'
require 'bundler/setup'
require 'simple_action'
require 'pry'

Dir[File.join('.', 'spec', 'support', '**', '*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
