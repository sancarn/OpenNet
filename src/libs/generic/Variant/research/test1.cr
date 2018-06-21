class Test(T)
  def initialize(var : T)
    @var = var
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
end

puts Test.new(1) + "1"
puts Test.new("1") + 1

# It twerks!!!!
