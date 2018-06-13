macro variant_wrap_math(t)
  struct Number
    def +(val : Variant({{t}}))
      self + {{t}}.new(val)
    end
    def -(val : Variant({{t}}))
      self - {{t}}.new(val)
    end
    def *(val : Variant({{t}}))
      self * {{t}}.new(val)
    end
    def /(val : Variant({{t}}))
      self / {{t}}.new(val)
    end
    def **(val : Variant({{t}}))
      self / {{t}}.new(val)
    end
  end
end

variant_wrap_math Int8
variant_wrap_math Int16
variant_wrap_math Int32
variant_wrap_math Int64
variant_wrap_math Int128
variant_wrap_math UInt8
variant_wrap_math UInt16
variant_wrap_math UInt32
variant_wrap_math UInt64
variant_wrap_math UInt128
variant_wrap_math Float32
variant_wrap_math Float64
variant_wrap_math Number

class Variant(T)
  @@auto_cast = false

  getter thisType
  def initialize(var : T)
    @var = var
    @thisType = T
  end
  def to_s(io : IO)
    io << @var.to_s
  end

  #Autocasting
  def self.auto_cast
    @@auto_cast
  end
  def self.auto_cast=(val)
    @@auto_cast=val
  end
  def self.auto_cast(&block)
    current = @@auto_cast
    @@auto_cast = true
      block.call
    @@auto_cast = current
  end
  forward_missing_to @var
end
