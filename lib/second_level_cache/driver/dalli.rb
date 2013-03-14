module SecondLevelCache
  module Store
    def read(name)
      get name
    end
    
    def write(name, value, options = nil)
      ttl = options[:expires_in].to_i if options && options[:expires_in]
      set name, value, ttl
    end
    
    def clear
      flush_all
    end
  end
end
