class Median
	def self.mean(n1,n2)
		n1+n2/2.0 

	end 
	def	self.check(numbers,queries)
		#queries.each do |query|
			end_points = queries.split(" ").map(&:to_i).sort
			if end_points[0] == end_points[1]
				p end_points[0]
			else
				end_points = (end_points[0]..end_points[1]).to_a
				if end_points.count == 2
					p end_points[0]
				else
					p "center"
					p center =  end_points.size / 2
					p end_points.size % 2 == 1 ? end_points[center] : self.mean(end_points[center-1],end_points[center])

				end	
			end	
			
				
			#puts (end_points.inject(:+)/2).to_i if numbers.include?(end_points[0]) && numbers.include?(end_points[1]) 
		#end
	end
end	

total_numbers = []
#total_queries = []

count = 0
numbers = gets.chomp.to_s
until numbers.to_i == count
	inp_cmd = gets.chomp.to_s
	total_numbers << inp_cmd.to_i 
	count = count+1
end

count = 0
samples = gets.chomp.to_s
until samples.to_i == count
	inp_cmd = gets.chomp.to_s
	total_queries = inp_cmd 
	Median.check(total_numbers,total_queries)
	count = count+1
end

