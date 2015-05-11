require 'curses'

Curses.noecho
Curses.init_screen

class Event
	hash = {:one=>1,:two=>2,:three=>3,:four=>4,:five=>5,:six=>6}
	def self.random_event
		events = ["one","two","three","four","five","six","bold","catch","lbw","no_ball","wide"]
		exe = rand(1..6)
		events[exe]
	end	
	[:two, :four, :six].each do |method_name|
		define_method method_name do |args|
			 bats_men =  args.batsmen
			 bats_men.add_point(hash[method_name.to_sym].to_i)
			 args.add_team_score(hash[method_name.to_sym].to_i)	
		end
	end	
	[:one, :three, :five].each do |method_name|
		define_method method_name do |args|
			 bats_men =  args.batsmen
			 bats_men.add_point(hash[method_name.to_sym].to_i)
			 args.add_team_score(hash[method_name.to_sym].to_i)
			 args.change_batsmen
		end
	end	
	[:bold, :catch, :lbw].each do |method_name|
		define_method method_name do |args|
			bats_men =  args.batsmen
			bats_men.out
			bats_men = args.next_batsmen
		end
	end
	[:no_ball, :wide].each do |method_name|
		define_method method_name do |args|
		method_name	
		end
	end
end	

class Ball
	attr_accessor :status, :event ,:over, :index
	def initialize(index,over)
		@over = over
		@index = index
	end	
end	

class Over
	def initialize(over)
		@index = over
		@balls = (1..6).map{ |index| Ball.new(index,over)}
	end	
	def index
		@index
	end	
	def balls
		@balls
	end	
end

class Player
	attr_accessor :status, :index , :team , :points
  def initialize(index,team)
  	@index = index
    @team = team
    @points = 0
  end

  def out
  	self.status = "out"
	#p "batsmen #{self.index} out"
  end

  def index
  	@index
  end	

  def add_point(points)
  	@points = @points + points
  	report
  end	

  def points
  	@points
  end

  def to_s
    "Player ##{'%2d' % @index} is #{'%3d' % @points}% score"
  end

  def report
    Curses.setpos(@index, 0)
    Curses.addstr(to_s)
    Curses.refresh
  end

end	

class Team
	attr_accessor :status, :score
	def initialize(team)
		@team_name = team
		@players = (1..10).map{ |index| Player.new(index,team)}
		@score = 0
	end

	def self.all
		ObjectSpace.each_object(Team).to_a
	end	

	def add_team_score(points)
		self.score = self.score + points
	end
		
	def team_name
		@team_name
	end	
	
	def players
		@players 
	end
	
	def change_batsmen
		batsmen1 = self.players.find{ |player| player.status == "on" }
		batsmen2 = self.players.find{ |player| player.status == "off" }
		batsmen1.status = "off"
		batsmen2.status = "on"
		#p "batsmen changed  batsmen #{batsmen2.index} batting "
	end
		
	def players_points
		@players.each do |player|
			p player.points
		end 
	end

	def play_batting
	end
	
	def batsmen
		batsmen = self.players.find{ |player| player.status == "on" }
		batsmen
	end
		
	def next_bowler(bowller)
		self.players.find{ |player| player.index == bowller.index.to_i + 1 }
	end	

	def next_batsmen
		batsmen = self.players.find{ |player| player.status == nil }
		batsmen.status = "on"
		batsmen
	end

end		

class Match

	def initialize(team1, team2)
		@team_a = Team.new(team1)
		@team_b = Team.new(team2)
		@score_a = 0
		@score_b = 0
		#puts "Match Initilized"
	end

	def teams
		teams = [@team_a,@team_b]
	end	

	def toss
		#puts "Toss"
		coin = rand(0..1)
		winner = coin == 0 ? @team_a : @team_b
		#puts "Toss won by team #{winner.team_name}"
		winner
	end	

	def session
		batting_team = self.teams.find{|team| team.status == "Batting"}
		bowling_team = self.teams.find{|team| team.status != "Batting"}
		batsmen1 = batting_team.players.first
		batsmen1.status = "on"
		batsmen2 = batting_team.next_batsmen
		bowller = bowling_team.players.first
		batsmen = batsmen1
		batsmen2.status = "off"
		
		@overs = (1..5).map{ |index| Over.new(index)}
		@overs.each do |over|
				#p "--------over #{over.index}----------"
				#p "------------------------------------"
			 over.balls.each do |ball|
			 	batsmen = batting_team.batsmen
			 	#p "batsmen #{batsmen.index} batting"
			 	event = Event.new
			  	event_name = Event.random_event
			 	ball.event = event_name
			    event.send(event_name.to_sym,batting_team)
			end 
		bowller = bowling_team.next_bowler(bowller)		
		end	
	end	

end		


at_exit do
	Team.all.each do |team|
	 team.players_points
	 p "Total team score #{team.score}"
 	end
end

match = Match.new("A","B")
winning_team = match.toss 
losing_team = match.teams.find{ |team| team.team_name != winning_team.team_name}
print "Batting or Bowling ? 0 for batting, 1 for bowling :  "
winner_input = Curses.getstr
winner_input = winner_input.chomp.to_i 
winner_input == 0 ? winning_team.status = "Batting" : losing_team.status = "Batting"
winner_input != 0 ? winning_team.status = "Bowling" : losing_team.status = "Bowling"
match.session
winner_input == 0 ? winning_team.status = "Bowling" : losing_team.status = "Bowling"
winner_input != 0 ? winning_team.status = "Batting" : losing_team.status = "Batting"
match.session

Curses.close_screen




