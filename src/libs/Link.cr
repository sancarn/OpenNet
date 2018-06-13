require 'json'
module OW
    class Link
      property id : String
      property type : String
      property us_node : Node | ::Nil
      property ds_node : Node | ::Nil
      getter category = "_links"
      property data : JSON::Any
      def initialize(id : String,sType : String, data = nil : JSON::Any|::Nil?)
        @id = id
        @type = sType
        @data = data
        @us_node = nil
        @ds_node = nil
      end
    end
end
