require 'json'
module ON
    class Subcatchment
      getter category = "_subcatchments"
      property data : JSON::Any
      property type  | String
    end
end
