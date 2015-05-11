class BrowserReport
	$vovels = ["a","e","i","o","u"]
	def self.job(input)
		input_count = input.split("").count
		input = input.split(".")
		middle = input[1].split("").reject{|c| $vovels.include?(c)}.count
		last = input[2].split("").count
		jh = middle + last + 1
		puts out_put = "#{jh}/#{input_count}"
	end
end	

count = 0
total_sample = gets.chomp.to_s
until total_sample.to_i == count
	inp_cmd = gets.chomp.to_s
	BrowserReport.job(inp_cmd) 
	count = count+1
end