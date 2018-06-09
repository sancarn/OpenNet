require "../src/Network.cr"

net = OW::Network.new()
node = net.nodes["c"]
node = node.us_links[0].us_node.us_links[0].us_node
puts node.id
puts node.type
