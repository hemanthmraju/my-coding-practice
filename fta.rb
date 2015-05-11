class Base
	attr_accessor :id
	def initialize(arg)
		@id = arg
	end	
	def self.all
		ObjectSpace.each_object(self).to_a	
	end
	class <<self
		[:id].each do |method_name|
			define_method "find_or_create_by_#{method_name}" do |arg|
				obj = self.all.find{|ob| ob.send(method_name).to_s == arg.to_s} 
			    obj.nil? ? self.new(arg) : obj
			end
		end
	end
end	

class Visitor < Base
end

class Room < Base
end

class Period < Base
	attr_accessor :visitor, :room, :time_in, :status, :time_out
	def initialize(v,r,st,t_in)
		@visitor = v.to_i
		@room = r.to_i
		@time_in = t_in.to_i
		@status = st
	end
	def self.exit_period(v,r,st,t_out)
		period = Period.all.find{ |p| p.visitor == v.to_i && p.room == r.to_i}
		period.time_out = t_out.to_i
		period.status = st
	end	
	def	self.job(inp)
		inp = inp.split(" ")
		visitor = Visitor.find_or_create_by_id(inp[0])
		room = Room.find_or_create_by_id(inp[1])
		case inp[2]
		when "I"
			Period.new(visitor.id,room.id,inp[2],inp[3])
		when "O"
			Period.exit_period(visitor.id,room.id,inp[2],inp[3])
		else
			puts "wrong input"
		end	
	end

end

inp_cmd = "entry"
until inp_cmd == "exit"
	inp_cmd = gets.chop
	Period.job(inp_cmd) unless inp_cmd == "exit"
end

Room.all.sort_by{ |r| r.id.to_i}.each do |room|
	p room.inspect
	period = Period.all.find_all{ |p|  p.room == room.id.to_i}
	total_time = 0
	period.each do |p|
		time = p.time_out.to_i - p.time_in.to_i
		total_time = total_time + time
	end
	p avg = total_time/period.count
end