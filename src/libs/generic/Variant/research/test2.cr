class Test(T)
  @@auto_cast = false

  def initialize(var : T)
    @var = var
  end
  def self.auto_cast
    @@auto_cast
  end
  def self.auto_cast=(val)
    @@auto_cast = val
  end

  def self.auto_cast(forced_value=true,&block)
    #Force value, but store initial value:
    ac = @@auto_cast
    @@auto_cast = forced_value
      block.call
    @@auto_cast = ac
  end

  def +(val)
    var = @var
    if @@auto_cast
      if var.is_a? String
        casted_arg = val.to_s
        return var + casted_arg
      else
        casted_arg = typeof(var).new(val)
        return var + casted_arg
      end
    else
      if typeof(var) != typeof(val)
        {{raise "Error: Type of <<var>> is not equal to type of <<val>> while auto_cast is false."}}
      else
        return var + val
      end
    end
  end
end

Test.auto_cast do
  puts Test.auto_cast
  puts Test.new(1) + "1"
  puts Test.new("1") + 1
end

# Fails to compile because:
# 1. Crystal compiler cannot be certain that @@auto_cast will be true whenever I intend to auto_cast (and to be fair, when auto-casting is disabled, I want the syntax error).
# 2. A compile error occurs because the value of @@auto_cast is unknown at compile time
# 3. Due to the contradictory nature of the bodies:
#      if var.is_a? String
#        casted_arg = val.to_s
#        return var + casted_arg
#      else
#        casted_arg = typeof(var).new(val)
#        return var + casted_arg
#      end
# and
#      if typeof(var) != typeof(val)
#        {{raise "Error: Type of <<var>> is not equal to type of <<val>> while auto_cast is false."}}
#      else
#        return var + val
#      end
# Each definition should only be used when the user explicitly declares it. Thus this is more suited to a macro.
