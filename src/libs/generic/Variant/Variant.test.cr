require "./Variant.cr"
macro testVariant(a, b, action)
  {{a}} {{action.id}} {{b}} == {{a}} {{action.id}} Variant.new({{b}})
end

puts testVariant 1.0,11,:+
