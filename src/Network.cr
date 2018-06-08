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

#    raw_nodes = [
#      {:id=>"a",:type=>"hw_manhole"},
#      {:id=>"b",:type=>"hw_manhole"},
#      {:id=>"c",:type=>"hw_manhole"}
#    ]
#    raw_links = [
#      {:id=>"a.1",:type=>"hw_conduit",:us_node=>"a",:ds_node=>"b"},
#      {:id=>"b.1",:type=>"hw_conduit",:us_node=>"b",:ds_node=>"c"},
#    ]

require "json"
raw_nodes = JSON.parse(File.open("../data/Nodes.json"))
raw_links = JSON.parse(File.open("../data/Links.json"))

nodes = {} of String => Node
links = {} of String => Link

raw_nodes.each do |iNode|
  nodes[iNode["id"].to_s] = Node.new(iNode["id"].to_s,iNode["type"].to_s)
end

raw_links.each do |iLink|
  link = Link.new(iLink["id"].to_s,iLink["type"].to_s)

  #us_node data
  us_node = nodes[iLink["us_node"].to_s]
  link.us_node = us_node
  us_node.ds_links << link

  #ds_node data
  ds_node = nodes[iLink["ds_node"].to_s]
  link.ds_node = ds_node
  ds_node.us_links << link
end

node = nodes["c"]
node = node.us_links[0].us_node.us_links[0].us_node
puts node.id
puts node.type
