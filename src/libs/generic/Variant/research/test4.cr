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
  {% File.write("/tmp/crystal_ac","1") %}
end
macro set_ac_false
  {% File.write("/tmp/crystal_ac","")  %}
end

macro auto_cast(forced_value=true,&block)
  #Force value, but store initial value:
  store_ac_current
  {%if forced_value%}
    set_ac_true
  {%else%}
    set_ac_false
  {%end%}
    block.body
  reset_ac_current
end


class Test(T)
  def initialize(var : T)
    @var = var
  end

  def +(val)
    var = @var
    {%if File.read("/tmp/crystal_ac")=="1"%}
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
  puts Test.auto_cast
  puts Test.new(1) + "1"
  puts Test.new("1") + 1
end

# File.write cannot be used within a macro...
