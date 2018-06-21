# Variant Spec:
# An attempt at a fully dynamic type
# VariantNAC is the Dynamic Type alone, Variant however
# will also try to auto-cast itself to a compatible value
#
# # Always prioritise casting of variant
# Variant.new("1") + 1 ==> 2
# 1 + Variant.new("1") ==> 2
# "1" + Variant.new(1) ==> "11"
# Variant.new(1) + "1" ==> "11"
#
# # As above when Variant meets VariantNAC:
# Variant.new("1") + VariantNAC.new(1) ==> 2
# VariantNAC.new(1) + Variant.new("1") ==> 2
# VariantNAC.new("1") + Variant.new(1) ==> "11"
# Variant.new(1) + VariantNAC.new("1") ==> "11"
#
# # Wherever a Variant meets another Variant,
# always prioritise the first value:
# Variant.new(1) + Variant.new("1") ==> Variant.new(2)
# Variant.new("1") + Variant.new(1) ==> Variant.new("11")
#
# # Allow possibility to extend to other non-standard classes
#
# # Possible a further VariantPreserve class should be created to store all possible values. E.G.:
# (VariantP.new(1) + VariantP.new("1")).to_i ==> 2
# (VariantP.new(1) + VariantP.new("1")).to_s ==> "11"
# (VariantP.new(1) + "1").to_i ==> 2
# (VariantP.new(1) + "1").to_s ==> "11"

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
  def initialize(var : T)
    @var = var
  end
  def to_s(io : IO)
    io << @var.to_s
  end
  def +(val)
    var = @var
    if var.is_a? String
      casted_arg = val.to_s
      return var + casted_arg
    else
      casted_arg = typeof(var).new(val)
      return var + casted_arg
    end
  end
  forward_missing_to @var
end

class VariantNAC(T)
  getter thisType
  def initialize(var : T)
    @var = var
    @thisType = T
  end
  def to_s(io : IO)
    io << @var.to_s
  end

  forward_missing_to @var
end
