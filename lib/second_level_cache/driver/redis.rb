module SecondLevelCache
  module Store
    def read(name)
      get name
    rescue Exception => e
      logger.error("RedisError : #{e.message}") if logger
      nil
    end

    def write(name, value, options = nil)
      multi do
        set name, value
        if options && options[:expires_in]
          expire(name, options[:expires_in].to_i)
        end
      end
    rescue Exception => e
      logger.error("RedisError : #{e.message}") if logger
      false
    end

    def delete(name, options = nil)
      del name
    rescue Exception => e
      logger.error("RedisError : #{e.message}") if logger
      false
    end

    def clear
      flushall
    rescue Exception => e
      logger.error("RedisError : #{e.message}") if logger
      false
    end

    def fetch(key, options=nil)
      val = read(key)
      if val.nil? && block_given?
        val = yield
        write(key, val, options)
      end
      val
    rescue Exception => e
      logger.error("RedisError : #{e.message}") if logger
    ensure
      val
    end
  end
end
