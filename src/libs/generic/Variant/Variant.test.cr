require "./Variant.cr"
macro testVariant(a, b, action)
  {{a}} {{action.id}} {{b}} == {{a}} {{action.id}} Variant.new({{b}})
end
macro testVariant2(result,a,b,action)
  {{result}} == {{a}} {{action.id}} Variant.new({{b}})
end


puts testVariant 1.0,11,:+
puts testVariant 1,11.0,:+
Variant.auto_cast do
  puts testVariant2 2, 1, "1", :+
  puts testVariant2 "11", "1", 1, :+
end
