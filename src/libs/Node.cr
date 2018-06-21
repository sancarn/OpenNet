require 'json'
module ON
    class Node
      property id : String
      property type : String
      property us_links : Array(Link)
      property ds_links : Array(Link)
      getter category = "_nodes"
      property data : JSON::Any
      def initialize(id : String,sType : String)
        @id = id
        @type = sType

        #Connectivity:
        @us_links = [] of Link
        @ds_links = [] of Link
        @us_subcatchments = [] of Subcatchment
      end
    end
end
