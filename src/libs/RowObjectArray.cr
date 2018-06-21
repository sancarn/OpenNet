module ON
  alias OBJECT = Node|Link|Subcatchment

  class RowObjectArray
    def initialize(*args)
      super(*args)
    end

    def row_objects(query | String)
      if ON::use_strict
        raise "No method 'row_objects' of Array"
      end
      ret = [] of OBJECT
      self.each do |obj|
        if obj.category.downcase == query.downcase || obj.type.downcase == query.downcase
          ret << obj
        end
      end
    end
    # obj = row_objects_thread("hw_subcatchment")
    # while obj[:thread].status || obj[:data].length>0 do
    #   var = obj.pop()
    #   #...
    # end
    def row_objects_thread(query | String)
      if ON::use_strict
        raise "No method 'row_objects' of Array"
      end
      this = self
      ret = [] of OBJECT
      worker = Worker.new(->{ret.length!=0}) do
        this.each do |obj|
          ret << obj
        end
      end
    end
    return {:data => ret, :worker => worker}
  end

  # Goal:
  #  def func()
  #    myArr = [1,2,3]
  #    ret = [] of Int32
  #    worker = Worker.new(->{ret.length!=0}) do
  #      myArr.each do |obj|
  #        ret << obj
  #      end
  #    end
  #  end
  #
  #  worker=func
  #  while worker.status
  #   newInt = result[1].pop()
  #   puts newInt * 2
  #  end
  class Worker
    property worker_thread
    def initialize(check : Proc, &block)
      @worker_thread = Thread.new do
        block.call
      end
    end
    def status()
      return check.call && Thread.status
    end
  end
end





=begin
  require "json"
  data =<<-END_DATA
  	{"a":"b","c":["d","e",1],"f":{"g":"h"}}
  END_DATA
  json = JSON.parse(data).as_h
  json["a"] = 200.to_i64
  p json

  puts typeof(json)
  puts typeof(json["a"])
  puts typeof(json["c"])
  puts typeof(json["f"])

  p json
=end
