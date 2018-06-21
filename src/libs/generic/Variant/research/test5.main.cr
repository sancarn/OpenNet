# WHEN COMPILE FINISHED - DELETE crystal_ac temporary file
#macro finished
#  {% File.delete("/tmp/crystal_ac") %}
#end

#Todo
macro store_ac_current
end
macro reset_ac_current
end

macro set_ac_true
  {% tmp=run("./research.test5.set_ac_true") %}
end
macro set_ac_false
  {% tmp=run("./research.test5.set_ac_false")  %}
end

macro auto_cast(forced_value=true,&block)
  #Force value, but store initial value:
  store_ac_current
  {%if forced_value%}
    set_ac_true
  {%else%}
    set_ac_false
  {%end%}
    {{block.body}}
  reset_ac_current
end


class Test(T)
  def initialize(var : T)
    @var = var
  end

  def +(val)
    var = @var

    {%if run("./research.test5.read_ac").stringify=="1"%}
      if var.is_a? String
        casted_arg = val.to_s
        return var + casted_arg
      else
        casted_arg = typeof(var).new(val)
        return var + casted_arg
      end
    {%else%}
      return var + val
    {%end%}
  end
end

auto_cast do
  puts Test.new(1) + "1"
  puts Test.new("1") + 1
end

# I have no idea why this doesn't work.
#
# This can never work because methods are only instantiated once:
#   https://stackoverflow.com/questions/50975844/crystal-lang-cross-macro-macro-variables/50977531#50977531
# All instances of the method will always act the same (their initial definition)
#
# So instead of Variant.auto_cast() we will just have Variant and VariantNAC (No auto-cast).
# It will be up to the user to use NAC/regular variant appropriately
