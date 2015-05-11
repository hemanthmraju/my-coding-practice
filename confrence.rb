class Base
	def self.all
		ObjectSpace.each_object(self).to_a.reverse	
	end
end	

class Talk < Base
	attr_accessor :id, :title, :time, :session
	@@intialize_id = 0
	def initialize(title,time)
		@@intialize_id+=1
		@id = @@intialize_id
		@title = title
		@time = time
	end
end

class Session
attr_accessor :id, :talks, :type, :max_time, :current_time
	@@intialize_id = 0
	def initialize(type,max_time)
		@@intialize_id+=1
		@id = @@intialize_id
		@max_time = max_time
		@current_time = 0
		@type = type
		@talks = []
	end	
end

class Track
	attr_accessor :id, :sessions, :track_time
	@@intialize_id = 0
	def initialize
		@@intialize_id+=1
		@id = @@intialize_id
		@sessions = []
		@track_time = 0
		@sessions << Session.new("morning",180)
		@sessions << Session.new("afternoon",240)	
	end	
end

class Confrence
	attr_accessor :id, :total_time, :tracks
	@@intialize_id = 0
	def initialize
		@@intialize_id+=1
		@id = @@intialize_id
		@total_time = 0
		@tracks = []
	end
end

inp_cmd = "entry"
until inp_cmd == "exit"
	inp_cmd = gets
	unless inp_cmd == "exit"
		inp_cmd = inp_cmd.split(" ")
		time = inp_cmd.pop
		time = time.gsub(/[^0-9]/i, '').to_i unless time == "lightning"
		time = 5 if time == "lightning"
		title = inp_cmd.join(" ")
		Talk.new(title,time) 
	end
end

total_time = Talk.all().map(&:time).inject(:+).to_i
confrence = Confrence.new()

until confrence.total_time == total_time
	track = Track.new()
	track.sessions.each do |session|
		Talk.all().each do |talk|
			temp = session.current_time + talk.time
			if temp <= session.max_time && talk.session.nil? 
				session.talks << talk
				talk.session = session.id
				session.current_time += talk.time
			end
		end
		track.track_time += session.current_time
	end
confrence.tracks << track
confrence.total_time +=track.track_time
end


confrence.tracks.each do |track|
	puts "\n \n Track #{track.id}"
	track.sessions.each do |session|
		puts "\n \n #{session.type} session "
		session.talks.each do |talk|
			puts "#{talk.title} \t #{talk.time} \n"
		end
	end
end


#p confrence