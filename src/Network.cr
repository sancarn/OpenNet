require "./libs/Node"
require "./libs/Link"
require "./libs/Subcatchment"
require "json"

module OW
    DEFAULT_OPTIONS = {
        :path_nodes => "../data/Nodes.json",
        :path_links => "../data/Links.json",
        :path_subcs => "../data/Subcs.json", #not yet implemented
        :geospatial_connectivity => "false"  #not yet implemented
    }
    class Network
        property nodes         = {} of String => Node
        property links         = {} of String => Link
        property subcatchments = {} of String => Subcatchment

        def initialize(options = {} of Symbol => String)
            options = DEFAULT_OPTIONS.merge(options)

            #Grap nodes data
            raw_nodes = JSON.parse(File.open("../data/Nodes.json"))

            #Map nodes data
            ###@nodes = {} of String => Node
            raw_nodes.each do |iNode|
                @nodes[iNode["id"].to_s] = Node.new(iNode["id"].to_s,iNode["type"].to_s)
            end

            #Grave links data
            raw_links = JSON.parse(File.open("../data/Links.json"))

            #Map links data
            ###@links = {} of String => Link
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

              @links[iLink["id"].to_s] = link
            end
        end
    end
end
