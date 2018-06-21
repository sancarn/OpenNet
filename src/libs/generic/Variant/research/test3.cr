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
    {%if @@auto_cast%}
      if var.is_a? String
        casted_arg = val.to_s
        return var + casted_arg
      else
        casted_arg = typeof(var).new(val)
        return var + casted_arg
      end
    {%else%}
      if typeof(var) != typeof(val)
        {{raise "Error: Type of <<var>> is not equal to type of <<val>> while auto_cast is false."}}
      else
        return var + val
      end
    {%end%}
  end
end

Test.auto_cast do
  puts Test.auto_cast
  puts Test.new(1) + "1"
  puts Test.new("1") + 1
end

# Fails to compile
#   in research.test3.cr:24: can't execute ClassVar in a macro
#     {%if @@auto_cast%}
# I.E. Class variable's value is not known at compile time. Thus
# compilation fails.
#
# Solution:
#   We need a variable which can be set, stored and retrieved at compile time
