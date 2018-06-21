module ON
    def strictMode(mode : Boolean, &block)
        userUseStrict = ON::use_strict
        ON::use_strict = mode
        block.yield
        ON::use_strict = userUseStrict
    end
    module ModelObjectMixins
        def navigate(query : String) : Object
            sClass = self.class.to_s
            case query
                when "us_node"
                    if ON::use_strict
                        if sClass == "Link"
                            return self.us_node
                        end
                    else
                        case sClass
                            when "Node"
                                if self.us_links.length > 0
                                    return self.us_links[0].us_node
                                else
                                    return nil
                                end
                            when "Link"
                                return self.us_node
                            when "Subcatchment"
                                return nil
                        end
                    end
                when "ds_node"
                    if ON::use_strict
                        if sClass == "Link"
                            return self.ds_node
                        end
                    else
                        case sClass
                            when "Node"
                                if self.ds_links.length > 0
                                    return self.ds_links[0].ds_node
                                else
                                    return nil
                                end
                            when "Link"
                                return self.ds_node
                            when "Subcatchment"
                                return self.ds_node
                        end
                    end
                when "ds_links"
                    if ON::use_strict
                        if sClass == "Node"
                            return self.ds_links
                        else
                            return [] of Link
                        end
                    else
                        case sClass
                            when "Node"
                                return self.ds_links
                            when "Link"
                                if self.ds_node
                                    return self.ds_node.ds_links
                                else
                                    return [] of Link
                                end
                            when "Subcatchment"
                                if self.ds_link
                                    return [self.ds_link]
                                elsif self.ds_node
                                    return self.ds_node.ds_links
                                end
                            #end_whens
                        end
                    end
                when "us_links"
                    if ON::use_strict
                        if sClass == "Node"
                            return self.us_links
                        else
                            return [] of Link
                        end
                    else
                        case sClass
                            when "Node"
                                return self.us_links
                            when "Link"
                                if self.us_node
                                    return self.us_node.us_links
                                else
                                    return [] of Link
                                end
                            when "Subcatchment"
                                return [] of Link
                            #end_whens
                        end
                    end
                when "all_us_links"

                when "all_ds_links"

                when "all_us_objects"

                when "all_ds_objects"

            end
        end
        private def MultiThreadedTrace(startObject : Node | Link | Subcatchment, direction : String)
            #tracedObjects -- Array to output
            tracedObjects = []
            tracedObjects << startObject

            # Begin trace
            threads = [] of Thread
            objectsToProcess = [] of Node | Link | Subcatchment
            processedIDs = {} of String => Boolean
            objectsToProcess << startObject
            while(objectsToProcess.length > 0)
                while(objectToTrace = objectsToProcess.pop())
                    threads << Thread.new() do
                        while (objs = getNextObjects(objectToTrace,direction)).length == 1
                            newObject = objs[0]
                            if processedIDs[objs[0].id]
                                tracedObjects << objectToTrace
                                objectToTrace = objs[0]
                            else
                                tracedObjects << objectToTrace
                                break
                            end
                        end
                        tracedObjects << objectToTrace
                        if objs.length > 1
                            objs.each do |obj|
                                objectsToProcess << obj
                            end
                        end
                    end
                end
                threads.each {|t| t.sync}
            end
            return tracedObjects


        end
        private def getNextObjects(obj : Node|Link|Subcatchment, direction : String)
            strictMode(false) do
                if typeof(obj) == Node
                    return obj.navigate(direction + "_links")
                elsif typeof(obj) == Link
                    return [obj.navigate(direction + "_node")]
                elsif typeof(obj) == Subcatchment
                    return [obj.ds_node,obj.ds_link,obj.ds_subcatchment]
                end
            end
        end
    end
end
