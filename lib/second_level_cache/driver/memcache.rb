module SecondLevelCache
  module Store
    def read(name)
      get name
    end
    
    def write(name, value, options = nil)
      ttl = options[:options] if options && options[:expires_in]
      set name, value, ttl
    end
    
    def clear
      flush_all
    end
	end
end
