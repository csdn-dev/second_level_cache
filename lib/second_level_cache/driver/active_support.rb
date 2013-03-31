module SecondLevelCache
  module Store

    def write(name, value, options = nil)
      value = RecordMarshal.dump(value)
      super(name, value, options)
    end

    def read(name, options = nil)
      val = super(name, options)
      RecordMarshal.load val
    end
  end
end
