# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler/setup'
require 'second_level_cache'
require 'test/unit'
require 'redis'
#require 'dalli'
#require 'active_support'

SecondLevelCache.configure do |config|
  config.expires_in = 5.days
  config.cache_store = :redis, Redis.new
#  config.cache_store = :dalli, Dalli::Client.new
#  config.cache_store = :active_support, ActiveSupport::Cache::MemoryStore.new
end

SecondLevelCache.logger.level = Logger::INFO
