require 'json'
net = WSApplication.current_network
nodes = net.row_object_collection("_nodes")
links = net.row_object_collection("_links")
subcs = net.row_object_collection("_subcatchments")

File.new("Nodes.json") do |file|
    file.puts("[")
    nodes.each do |node|
        hash = {
            "id"   => node.id,
            "type" => node.table_info.name,
            "geo"  => {"x"=>node.x,"y"=>node.y},
            "data" => {}
        }
        node.table_info.fields.each do |field|
            hash["data"][field.name] = node[field.name]
        end
        file.puts("  " + hash.to_json)
    end
    file.puts("]")
end

File.new("Links.json") do |file|
    file.puts("[")
    links.each do |link|
        hash = {
            "id"   => link.id,
            "type" => link.table_info.name,
            "geo"  => [],
            "us_node" => link.us_node.id,
            "ds_node" => link.ds_node.id,
            "data" => {}
        }
        link.point_array.each_slice(2).each do |slice|
            hash["geo"].push({
                "x"=>slice[0],
                "y"=>slice[1]
            })
        end
        link.table_info.fields.each do |field|
            hash["data"][field.name] = link[field.name]
        end
        file.puts("  " + hash.to_json)
    end
    file.puts("]")
end

File.new("Subcatchments.json") do |file|
    file.puts("[")
    subcs.each do |subc|
        hash = {
            "id"   => subc.id,
            "type" => subc.table_info.name,
            "ds_node" =>subc.node_id,
            "ds_link" =>subc.link_id,
            "ds_subcatchment" =>subc.subcatchment_id,
            "geo"  => [],
            "data" => {}
        }
        subc.point_array.each_slice(2).each do |slice|
            hash["geo"].push({
                "x"=>slice[0],
                "y"=>slice[1]
            })
        end
        subc.table_info.fields.each do |field|
            hash["data"][field.name] = subc[field.name]
        end
        file.puts("  " + hash.to_json)
    end
    file.puts("]")
end
