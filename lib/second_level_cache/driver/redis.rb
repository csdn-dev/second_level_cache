module SecondLevelCache
  module Store
    def read(name)
      get name
    end
    
    def write(name, value, options = nil)
      set name, value
      if options && options[:expires_in]
        expire(name, options[:expires_in].to_i)
      end
    end
    
    def delete(name, options = nil)
      del name
    end
    
    def clear
      flushall
    end
	end
end
