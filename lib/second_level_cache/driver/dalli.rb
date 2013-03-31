module SecondLevelCache
  module Store
    def read(name)
      RecordMarshal.load get(name)
    rescue Exception => e
      logger.error("DalliError (#{e}): #{e.message}") if logger
      nil
    end

    def write(name, value, options = nil)
      ttl = options[:expires_in].to_i if options && options[:expires_in]
      set name, RecordMarshal.dump(value), ttl
    rescue Exception => e
      logger.error("DalliError (#{e}): #{e.message}") if logger
      false
    end

    def clear
      flush_all
    rescue Exception => e
      logger.error("DalliError (#{e}): #{e.message}") if logger
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
      logger.error("DalliError (#{e}): #{e.message}") if logger
    ensure
      val
    end
  end
end
