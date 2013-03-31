# -*- encoding : utf-8 -*-
module SecondLevelCache
  module Config
    extend self

    attr_accessor :cache_driver, :cache_store, :logger, :cache_key_prefix, :expires_in
    def cache_store=(store_option)
      store, @cache_store = store_option
      begin
        require "second_level_cache/driver/#{store}"
      rescue LoadError => e
        raise "Could not find cache store adapter for #{store} (#{e})"
      end
      @cache_store.extend(SecondLevelCache::Store)
    end

    def logger
      @logger ||= ::Rails.logger if defined?(::Rails)
      @logger ||= Logger.new(STDOUT)
    end

    def cache_key_prefix
      @cache_key_prefix ||= 'slc'
    end

    def expires_in
      @expires_in ||= 1.week
    end
  end

  module Store
    def run(operation, key, val = nil, options = nil)
      result = if operation == :write
        self.send operation, key, val, options
      else
        self.send operation, key
      end
      cache_log(operation, key, options) unless SecondLevelCache.cache_store.respond_to?(:log, true)
      result
    rescue Exception => e
      SecondLevelCache.logger.warn e
      nil
    end

    private
    def logger
      SecondLevelCache.logger
    end

    def cache_log(operation, key, options = nil)
      return unless logger && logger.debug?
      logger.debug("Cache #{operation}: #{key}#{options.blank? ? "" : " (#{options.inspect})"}")
    end
  end
end

