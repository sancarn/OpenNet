module OW
    class Link
      property id : String
      property type : String
      property us_node : Node
      property ds_node : Node
      def initialize(id : String,sType : String)
        @id = id
        @type = sType

        @us_node = Node.new("","nil")
        @ds_node = Node.new("","nil")
      end
    end
end
