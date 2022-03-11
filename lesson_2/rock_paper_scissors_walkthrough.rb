class Player
  def initialize
    # maybe a "name"? what about a "move"?
  end

  def choose

  end
end

class Move
  def initialize
    # seems like we need something to keep track
    # of the choice... a move object can be "paper", "rock" or "scissors"
  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2)

end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end

class Banner
  def initialize(message, size=message.size)
    @message = message
    size_error('small') if size < @message.size
    size_error('big') if size > 80
    @size = size
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  DASH = '-'
  SPACE = ' '

  def size_error(state)
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

  def message_line
    "| #{@message.center(@size)} |"
  end
end

RPSGame.new.play
