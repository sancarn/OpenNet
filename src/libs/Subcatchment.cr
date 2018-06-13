require 'json'
module OW
    class Subcatchment
      getter category = "_subcatchments"
      property data : JSON::Any
      property type  | String
    end
end
