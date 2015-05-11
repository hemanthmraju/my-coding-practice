class Base
	def self.all
		ObjectSpace.each_object(self).to_a
	end
	def try(input)
		obj = self.send(input.to_s)
		obj.nil? ? 0 : obj
	end	
	class <<self
		[:number, :color, :index , :car_index, :status, :car].each do |method_name|
			define_method "find_by_#{method_name}" do |args|
				self.all.find{ |ob| ob.send(method_name).to_s == args.to_s}
			end
			define_method "find_all_by_#{method_name}" do |args|
				self.all.find_all{ |ob| ob.send(method_name).to_s == args.to_s}
			end
		end	
	end

end	

class Car < Base
	@@car_index = 1
	attr_accessor :number, :color, :index , :car_index
	def initialize(number,color)
		@index = @@car_index
		@number = number
		@color = color
		@@car_index = @@car_index + 1 
	end	
end	

class Slot < Base
	attr_accessor :index, :status, :car

	def initialize(index)
		@index = index
		@status = "free"
		@car = 0
	end	
	def self.get_slot
		Slot.all.reverse.find{|slot| slot.status == "free"}
	end
	def assign_slot(index)
		@car = index
		@status = "occupied"
	end	
	def leave_slot
		@car = 0
		@status = "free"
	end	
end	

class Ticket < Base
	@@ticket_number = 1
	attr_accessor :car_index, :slot_index , :ticket, :ticket_number
	def initialize(car_index,slot_index)
		@car_index = car_index
		@slot_index = slot_index
		@ticket = @@ticket_number
		@@ticket_number = @@ticket_number + 1
	end	
end

class ParkingLot < Base
	def initialize(count)
		(1..count).map{|index| Slot.new(index)}
		puts "Created a parking lot with #{count} slots"
	end	
	def issue_ticket(car_index,slot_index)
		Ticket.new(car_index,slot_index)
	end	
	def park_me(car_number,color)
		car1 = Car.new(car_number,color)
		slot = Slot.get_slot
		unless slot.nil?
			slot.assign_slot(car1.index) 
			ticket = self.issue_ticket(car1.index,slot.index)
			puts "Allocated slot number: #{slot.index}"
		else
			puts "Sorry, parking lot is full"
		end
	end	
	def leave_me(id)
		slot = Slot.find_by_index(id)
		slot.leave_slot
		p "Slot number #{slot.index} is free"
	end	
	def self.status
		puts " Slot No.   Registration No    Color   "
		Slot.all.each do |slot|
			if slot.status == "occupied"
				car = Car.find_by_index(slot.car)
				puts "  #{slot.index}          #{car.number}      #{car.color}  "
			end
		end	
	end	
	def self.job(inp_cmd)
		input = inp_cmd.split(" ")
		case input[0] 
			when "create_parking_lot"
				ParkingLot.new(input[1].to_i)
			when "park"
				parking_lot = ParkingLot.all.first
				parking_lot.park_me(input[1],input[2])	
			when "leave"		
				parking_lot = ParkingLot.all.first
				parking_lot.leave_me(input[1].to_i)
			when "registration_numbers_for_cars_with_colour"
				cars = Car.find_all_by_color(input[1])	
				cars.map { |c| p c.number  }
			when "slot_numbers_for_cars_with_colour"
				cars = Car.find_all_by_color(input[1])	
				if cars
			    cars.each do |c| 
			    	 slot = Slot.find_by_car(c.index)
			    	 puts slot.try(:index) unless slot.nil?
			    	end
				else
					puts "car not found" 
				end
			when "slot_number_for_registration_number"
				car = Car.find_by_number(input[1])
				if car 	
				puts Slot.find_by_car(car.index).index		
				else
					puts "car not found"
				end	
			when "status"
				ParkingLot.status			
			else
			puts "wrong input"	
		end	
	end
end	

puts "please enter the command"
inp_cmd = "entry"
until inp_cmd == "exit"
	inp_cmd = gets.chomp.to_s
	ParkingLot.job(inp_cmd) unless inp_cmd == "exit"
end





