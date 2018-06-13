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
    block.call()
    @@auto_cast = current
  end
  macro method_missing(call)
    puts {{call.name.stringify}}
    puts {{call.args[0]}}
    if {{call.name.stringify}}=="+"
      if @@auto_cast
        if typeof(@var)!=typeof({{call.args[0]}})
          casted_arg = typeof(@var).new({{call.args[0]}})
          return @var.{{call.name}}(casted_arg)
        else
          return @var.{{call.name}}({{*call.args}})
        end
      end
    else
      return @var.{{call.name}}({{*call.args}})
  	end
  end
end

Variant.auto_cast do
  puts Variant.new(1) + "1"
end
