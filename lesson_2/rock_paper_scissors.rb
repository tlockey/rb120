=begin
Textual Description of Rock Paper Scissors:
Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

Nouns: player, move, rule
Verbs: choose, compare

Player
- choose

Move
Rule

- compare

This was my attempt at making an OOP Rock Paper Scissors Game.

AREAS FOR IMPROVEMENT:
- The bannerizer in the SCOREBOARD doesn't work so well if the name is
  longer than 4 characters, because of '\t'
- If the user enters a non-integer value for max number of points
  the computer doesn't catch it, because I'm calling to_i on the input
  so any non integer character automatically is 0.
=end
BANNER_SIZE = 40
require 'pry'

class Player
  attr_accessor :name, :move, :points, :history

  def initialize()
    @name = nil
    @move = nil
    @points = 0
    @history = []
  end

  def display_history
    move_list = ["#{name.upcase}'S MOVES"] + @history
    puts Banner.new(move_list, BANNER_SIZE)
  end
end # end Player class

class Human < Player
  def initialize
    super()
    ask_name()
  end

  def choose
    puts "Rock, Paper, Scissors, Lizard or Spock?"
    @move = Move.new(gets.chomp.capitalize)
    @history << @move.to_s
  end

  private

  def ask_name
    puts "What's your name?"
    name = ''
    loop do
      name = gets.chomp.capitalize
      break unless name.empty?
      puts "Please enter a name."
    end
    self.name = name
  end
end # end Human Class

class Computer < Player
  attr_accessor :personality
  NAMES = %w(Jimbo Donna Didi Lisi Qin)

  def initialize
    super
    @name = NAMES.sample
    @personality = grab_personality(name)
  end

  def choose
    choice = @personality.choose
    @move = Move.new(choice)
    @history << @move.to_s
  end

  private

  def grab_personality(name)
    case name
    when 'Qin' then Qin.new
    when 'Donna' then Donna.new
    when 'Lisi' then Lisi.new
    when 'Jimbo' then Jimbo.new
    when 'Didi' then Didi.new
    end
  end
end # end Computer class

class Qin < Computer
  # Emperor Qin sometimes has a tendency to choose paper
  def initialize;end

  def choose
    choices = Move::CHOICES.sample(3)
    choices.include?('Paper') ? 'Paper' : choices.first
  end
end

class Donna < Computer
  # Donna sometimes has a tendency to choose rock
  def initialize;end

  def choose
    choices = Move::CHOICES.sample(3)
    choices.include?('Rock') ? 'Rock' : choices.first
  end
end

class Lisi < Computer
  # Lisi is old school, believes only in the original 
  # three, so never picks Spock or Lizard
  def initialize;end
  
  def choose
    ['Rock', 'Paper', 'Scissors'].sample
  end
end

class Jimbo < Computer
  # No one ever taught Jimbo not to run with scissors
  # So that's all he ever does
  def initialize;end

  def choose
    'Scissors'
  end
end

class Didi < Computer
  # Perhaps to make up for the predictable rhythm of his name,
  # Didi likes to keep you guessing
  def initialize;end

  def choose
   Move::CHOICES.sample
  end

end

class Move
  attr_reader :type

  CHOICES = ['Rock',
             'Paper',
             'Scissors',
             'Lizard',
             'Spock']

  def initialize(type)
    @type = Move.valid?(type) ? new_move(type) : ask_valid_type
  end

  def self.generate_random
    Move.new(CHOICES.sample)
  end

  def <(other)
    type < other.type
  end

  def >(other)
    type > other.type
  end

  def ==(other)
    type.class == other.type.class
  end

  def self.valid?(type)
    CHOICES.include?(type)
  end

  def to_s
    @type.to_s
  end

  private

  def new_move(type)
    case type
    when "Rock" then Rock.new
    when "Paper" then Paper.new
    when "Scissors" then Scissors.new
    when "Lizard" then Lizard.new
    when "Spock" then Spock.new
    end
  end

  def ask_valid_type
    type = ''
    loop do
      puts "Please enter a valid type (Rock, Paper, Scissors, Lizard, Spock):"
      type = gets.chomp.capitalize
      break if Move.valid?(type)
    end # end loop
    new_move(type)
  end # end get valid type
end # end Move Class

class Rock < Move
  def initialize; end

  def <(other)
    other.class == Paper ||    # Paper covers Rock
      other.class == Spock     # Spock vaporizes Rock
  end

  def >(other)
    other.class == Lizard ||   # Rock crushes Lizard
      other.class == Scissors  # Rock smashes Scissors
  end

  def to_s
    "Rock"
  end
end # End Rock Class

class Scissors < Move
  def initialize; end

  def <(other)
    other.class == Spock ||    # Spock smashes Scissors
      other.class == Rock      # Rock crushes Scissors
  end

  def >(other)
    other.class == Paper ||    # Scissors cuts Paper
      other.class == Lizard    # Scissors decapitates Lizard
  end

  def to_s
    "Scissors"
  end
end # End Scissors Class

class Paper < Move
  def initialize; end

  def <(other)
    other.class == Scissors || # Scissors cuts paper
      other.class == Lizard    # Lizard eats paper
  end

  def >(other)
    other.class == Spock ||    # Paper disproves Spock
      other.class == Rock      # Paper covers Rock
  end

  def to_s
    "Paper"
  end
end # End Paper Class

class Lizard < Move
  def initialize; end

  def <(other)
    other.class == Scissors || # Scissors Decapitates Lizard
      other.class == Rock      # Rock crushes Lizard
  end

  def >(other)
    other.class == Spock ||    # Lizard poisons Spock
      other.class == Paper     # Lizard eats Paper
  end

  def to_s
    "Lizard"
  end
end # End Lizard Class

class Spock < Move
  def initialize; end

  def <(other)
    other.class == Paper ||   # Paper disproves Spock
      other.class == Lizard   # Lizard Poisons Spock
  end

  def >(other)
    other.class == Rock ||    # Spock vaporizes Rock
      other.class == Scissors # Spock smashes Scissors
  end

  def to_s
    "Spock"
  end
end # End Spock Class

class RPSGame
  attr_accessor :human, :computer, :rounds, :points_max, :lead, :summary

  def initialize
    @lead = nil
    @human = Human.new
    @computer = Computer.new
    @rounds = 1
    @summary = []
  end

  def play
    loop do # start new game
      display_welcome_message
      ask_point_max
      loop do # game to max wins
        human.choose
        computer.choose
        display_winner
        find_lead
        display_points
        self.rounds += 1
        break if computer.points == points_max || human.points == points_max
      end # end round

      puts Banner.new("#{lead.upcase} WINS!", BANNER_SIZE)
      display_summary
      break unless play_again?
    end # end game
    say_goodbye
  end # end play def

  private

  def ask_point_max
    puts "How many points do you want to play to?"
    answer = gets.chomp.to_i
    loop do
      break if answer.is_a?(Integer)
      puts "Sorry, must enter valid integer."
      answer = gets.chomp.to_i
    end
    self.points_max = answer
  end

  def display_points
    scoreboard = ["SCOREBOARD",
                  "#{human.name} \t #{human.points}",
                  "#{computer.name} \t #{computer.points}",
                  "#{lead} is in the lead!"]

    puts Banner.new(scoreboard, BANNER_SIZE)
  end

  def display_welcome_message
    welcome_message = ["Welcome to Rock Paper Scissors",
                       " #{human.name} VS #{computer.name}"]
    puts Banner.new(welcome_message, BANNER_SIZE)
  end

  def find_lead
    # CHECK THIS, MIGHT CAUSE ERROR
    self.lead = 
    if human.points == computer.points
      "No one"
    elsif human.points > computer.points
      human.name
    else
      computer.name
    end
  end

  def display_winner # ABC ERROR, TOO MANY LINES
    outcome = ''
    winner = ''

    if human.move == computer.move
      outcome = "It's a tie!"
      winner = "No one"
    elsif human.move > computer.move
      outcome = "#{human.move} beats #{computer.move}"
      winner = human.name
      human.points += 1
    else
      outcome = "#{computer.move} beats #{human.move}"
      winner = computer.name
      computer.points += 1
    end

    game_play = ["ROUND #{rounds}",
                 "#{human.name} chose #{human.move}",
                 "#{computer.name} chose #{computer.move}",
                 outcome,
                 "#{winner} wins this time!"]

    system('clear')
    puts Banner.new(game_play, BANNER_SIZE)
    new_summary(human.move, computer.move, winner)
  end

  def new_summary(human_move, computer_move, winner)
    if @summary == []
      human_name = human.name[0..3].upcase
      comp_name = computer.name[0..3].upcase
      @summary = ["SUMMARY",
                "#{human_name}    #{comp_name}    WIN?"]
    end

    winner = winner == 'No one' ? '----' : winner[0..3]
    human_move = human_move.to_s[0..3]
    computer_move = computer_move.to_s[0..3]

    @summary << "#{human_move}    #{computer_move}    #{winner}"
  end

  def display_summary
    puts Banner.new(@summary, BANNER_SIZE)
  end

  def play_again?
    puts "Play again? (Y/N)"
    answer = gets.chomp.downcase
    loop do
      break if ['y', 'n'].include?(answer)
      puts "Sorry, Y or N only."
      answer = gets.chomp.downcase
    end
    answer == 'y'
  end

  def say_goodbye
    puts "Bye bye #{human.name}! Thanks for playing with #{computer.name}."
  end
end # end RPSGame Class

### BANNER CLASS
class Banner 
  def initialize(message, size=nil)
    if message.is_a?(Array)
      @message = message
    else
      @message = [message]
    end
    @size = size.nil? ? message.map(&:size).max : size
    size_error('small') if size < @message.size
    size_error('big') if size > 80
  end

  def to_s
    ([horizontal_rule, empty_line] +
      message_line +
      [empty_line, horizontal_rule]).join("\n")
  end

  private

  DASH = '-'
  SPACE = ' '

  def size_error(state) # TOO MANY LINES ERROR
    case state
    when 'small'
      loop do
        puts "Size too small. Enter a size larger than #{@message.size}."
        @size = gets.chomp.to_i
        break if @size >= @message.size
      end
    when 'big'
      loop do
        puts "Size too big. Enter a size smaller than 80."
        @size = gets.chomp.to_i
        break if @size <= 80
      end
    end
  end

  def horizontal_rule
    "+-#{DASH * @size}-+"
  end

  def empty_line
    "| #{SPACE * @size} |"
  end

  def message_line # return an array of lines
    @message.map do |line|
      "| #{line.center(@size)} |"
    end
  end
end

RPSGame.new.play
