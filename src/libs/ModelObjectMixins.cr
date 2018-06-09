module OW
    module ModelObjectMixins
        def navigate(query : String) : Object
            sClass = self.class.to_s
            select query
                case "us_node"
                    if OW::use_strict
                        if sClass == "Link"
                            return self.us_node
                        end
                    else
                        select sClass
                            case "Node"
                                if self.us_links.length > 0
                                    return self.us_links[0].us_node
                                else
                                    return nil
                                end
                            case "Link"
                                return self.us_node
                            case "Subcatchment"
                                return nil
                        end
                    end
                case "ds_node"
                    if OW::use_strict
                        if sClass == "Link"
                            return self.ds_node
                        end
                    else
                        select sClass
                            case "Node"
                                if self.ds_links.length > 0
                                    return self.ds_links[0].ds_node
                                else
                                    return nil
                                end
                            case "Link"
                                return self.ds_node
                            case "Subcatchment"
                                return self.ds_node
                        end
                    end
                case "ds_links"
                    if OW::use_strict
                        if sClass == "Node"
                            return self.ds_links
                        else
                            return [] of Link
                        end
                    else
                        select sClass
                            case "Node"
                                return self.ds_links
                            case "Link"
                                if self.ds_node
                                    return self.ds_node.ds_links
                                else
                                    return [] of Link
                                end
                            case "Subcatchment"
                                if self.ds_link
                                    return [self.ds_link]
                                elsif self.ds_node
                                    return self.ds_node.ds_links
                                end
                            #end_cases
                        end
                    end
                case "us_links"
                    if OW::use_strict
                        if sClass == "Node"
                            return self.us_links
                        else
                            return [] of Link
                        end
                    else
                        select sClass
                            case "Node"
                                return self.us_links
                            case "Link"
                                if self.us_node
                                    return self.us_node.us_links
                                else
                                    return [] of Link
                                end
                            case "Subcatchment"
                                return [] of Link
                            #end_cases
                        end
                    end
                case "all_us_links"
                    
                case "all_ds_links"

                case "all_us_objects"

                case "all_ds_objects"

            end
        end
    end
end
