$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
gem 'minitest'
require 'test/unit'
require 'rails'
require 'rails/test_help'
require 'active_record'


config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")


module Rails
  class Cache
    @@data = {}
   
     class << self
      def fetch(key, options = {})
        @@data[key] ||= yield
      end
      
      def write(key, value)
        @@data[key] = value
      end
      
      def read(key)
        @@data[key]
      end
     end
  end
  
  def self.cache
    return Cache
  end
  
  def self.version
    '2.1.0'
  end
end

require "#{File.dirname(__FILE__)}/../init"