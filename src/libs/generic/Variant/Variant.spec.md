# Variant Spec:
An attempt at a fully dynamic type.

The core `Variant` class will serve as a dynamic type and will also try to auto-cast itself to a compatible value in standard operations.

`VariantNAC` has a dynamic type but has **no auto-casting** rules.

----

## Rules:
* Wherever casting is required **always** prioritise casting of `Variant`:

```crystal
Variant.new("1") + 1 ==> 2
1 + Variant.new("1") ==> 2
"1" + Variant.new(1) ==> "11"
Variant.new(1) + "1" ==> "11"
```

* As above when `Variant` meets `VariantNAC`:

```crystal
Variant.new("1") + VariantNAC.new(1) ==> 2
VariantNAC.new(1) + Variant.new("1") ==> 2
VariantNAC.new("1") + Variant.new(1) ==> "11"
Variant.new(1) + VariantNAC.new("1") ==> "11"
```

* Wherever a `Variant` meets another `Variant`, always prioritise the **first** value:

```crystal
Variant.new(1) + Variant.new("1") ==> Variant.new(2)
Variant.new("1") + Variant.new(1) ==> Variant.new("11")
```

* Allow possibility to extend to other non-standard classes

----

## Future possible implementations

* `VariantPreserve` (alias `VariantP`) class to be created to store all possible final values. E.G.:

```crystal
(VariantP.new(1) + VariantP.new("1")).to_i ==> 2
(VariantP.new(1) + VariantP.new("1")).to_s ==> "11"
(VariantP.new(1) + "1").to_i ==> 2
(VariantP.new(1) + "1").to_s ==> "11"
```

----
