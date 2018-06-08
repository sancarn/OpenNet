class Node
  property id : String
  property type : String
  property us_links : Array(Link)
  property ds_links : Array(Link)
  def initialize(id : String,sType : String)
    @id = id
    @type = sType
    
    #Connectivity:
    @us_links = [] of Link
    @ds_links = [] of Link
    @us_subcatchments = [] of Subcatchment
  end
end

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

class Subcatchment
  
end

raw_nodes = [
  {:id=>"a",:type=>"hw_manhole"},
  {:id=>"b",:type=>"hw_manhole"},
  {:id=>"c",:type=>"hw_manhole"}
]
raw_links = [
  {:id=>"a.1",:type=>"hw_conduit",:us_node=>"a",:ds_node=>"b"},
  {:id=>"b.1",:type=>"hw_conduit",:us_node=>"b",:ds_node=>"c"},
]
nodes = {} of String => Node
links = {} of String => Link

raw_nodes.each do |iNode|
  nodes[iNode[:id]] = Node.new(iNode[:id],iNode[:type])
end

raw_links.each do |iLink|
  link = Link.new(iLink[:id],iLink[:type])
  
  #us_node data
  us_node = nodes[iLink[:us_node]]
  link.us_node = us_node
  us_node.ds_links << link
  
  #ds_node data
  ds_node = nodes[iLink[:ds_node]]
  link.ds_node = ds_node
  ds_node.us_links << link
end

node = nodes["c"]
node = node.us_links[0].us_node.us_links[0].us_node
puts node.id
puts node.type
