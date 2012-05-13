# encoding: utf-8
require 'simplecov'
require 'active_record'
require 'active_support'

SimpleCov.start do
  root File.join(File.dirname(__FILE__), '..')
  add_filter "/bin/"
  add_filter "/spec/"
end

$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'json_schema_builder'
require 'fixtures/user'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

ActiveRecord::Base.establish_connection({
  'adapter' => 'sqlite3',
  'database' => ':memory:'
})
load(File.join(File.dirname(__FILE__), 'fixtures/ar_schema.rb'))