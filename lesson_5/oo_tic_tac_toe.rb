=begin
TicTactoe:
1. write a description of problem.
  TicTacToe is a two player game. Each player marks off a square on a board.
  the first player to reach three of their markers in a row is the winner.
  The board is a 3x3 square. 
  In a row can mean diagonally, horizontally or vertically.
  3x3 board: (n = 3)

   x |   |    # active line
  ---+---+--- # divider line
   o | x | o  # active line
  ---+---+--- # divider line
   x | o |    # active line

  5 x 5 board: (n = 5)
   x |   |   |   |    # active line
  ---+---+---+---+--- # divider line
   o | x | o |   |    # active line
  ---+---+---+---+--- # divider line
   x | o |   |   |    # active line
  ---+---+---+---+--- # divider line
     |   |   |   |    # active line
  ---+---+---+----+---- # divider line
     |   |   | 33 | 34    # active line

  There is always (n) number of active lines, joined by (n-1) number of 
  divider lines. Can I .join something using the return value of a method?

  I have a board of squares. Players can be two humans, or a human versus a 
  computer.
2. Extract major nouns and verbs:
  Nouns: board, square, players, markers, rows
  Verbs: play, mark
3. Make an initial guess at organizing the verbs into nouns.
- TTT Engine:
  - play

- Board
  - Square

- Player
    - Markers
    - Human
    - Computer

The board is an object that players can act on. So it doesn't have any 
behaviors, except maybe initializing a new one. 

IMPROVEMENTS:
- Player Class:
  [/] Add @points
  [/] Capitalize entered names

- Computer Class:
  [ ] AI Offense
  [ ] Defense

- Board Class:
  [/] Change 'available' to 'unmarked'
  [/] Should I make setting states more explicit in init method?
  [/] Change 'is_full?' to 'full?'
  [/] Change 'find_available' to 'find_unmarked'
  [/] Add Clear Screen to Board#display method
  [/] Fix Reference Board for double digit numbers
  [/] Change Reference Board method names to be more explicit if needed
  [/] change Reference = true to reference: true, and call it, reference:true

- TTTGame Class:
  [/] Display Player Name and Marker
  [/] Refactor Play method
    [/] Specifically Loop -> Move System Clear to Display method
    [/] use current player logic instead of player 1, player 2 in loop 
  [/] Exit Game at 5 Points [/] Play to 5 points
  [/] In 2 Player Mode, Display Whose Turn it is

- Banner Class:
  [ ] How to deal with long strings, aside from just throwing an error?
  [/] How to deal with displaying the reference board?

- General refactoring
  [ ] make sure each method does only one thing,
  [ ] extract extra logic if needed
  [/] make private methods private
  [/] make sure each class is only concerned with its own affairs
  [/] reduce dependency if possible.

- method rename:
  [ ] make sure all methods are appropirately named:
  [ ] we can easily guess what the return value is 


=end
require 'pry'
### PLAYER CLASS

class Player
  attr_accessor :name, :marker, :points

  def initialize
    @name = nil
    @marker = nil
    @points = 0
  end

  def to_s
    @name
  end
end

### HUMAN CLASS

class Human < Player
  def initialize
    super()
    ask_name
  end

  def choose_square(board)
    board.display_reference
    puts "Which Square?"
    selection = gets.chomp.to_i
    loop do 
      break if board.unmarked.include?(selection)
      puts "Sorry, please pick an available square."
      selection = gets.chomp.to_i
    end
    board.mark_square(selection, marker)
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
  end # end ask_name
end # end Human Class

### COMPUTER CLASS

class Computer < Player
  NAMES = ['Stan', 'Jack', 'Joe']
  def initialize
    super()
    self.name = NAMES.sample
    puts "Hi there! I'm #{name}."
  end

  def choose_square(board)
    selection = board.unmarked.sample
    board.mark_square(selection, marker)
  end

end

### SQUARE CLASS

class Square
  attr_accessor :mark

  def initialize
    @mark = nil
  end

  def to_s
    @mark ? @mark : " "
  end
end

### BOARD CLASS

class Board
  attr_accessor :unmarked, :horizontals, :diagonals, :verticals

  def initialize(n)
    # visual representation of board is separate from square data
    @grid_size = n
    @squares = make_squares(@grid_size)
    @unmarked = find_unmarked
    @horizontals = find_horizontals # returns horizontal rows as nested array of indexes 
                                    # [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    @diagonals = find_diagonals     # [[0, 4, 8], [2, 4, 6]]
    @verticals = find_verticals     # [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
  end

  def mark_square(square, marker)
    index = square - 1
    @squares[index].mark = marker
    @unmarked = find_unmarked
  end

  def to_s
    @squares.each { |square| puts square.to_s }
  end

  def size
    @grid_size
  end

  def display(n=@grid_size, heading=nil)
    system('clear')
    puts heading unless heading.nil?
    puts make_active_lines(n).join(make_divider_line(n))
  end

  def display_reference
    # How can I make this display within a banner?
    # Instead of a full string, how can I pass in an array
    # to the Banner class
    # Or should I modify the Bannerclass?
    puts "REFERENCE"
    puts make_active_lines(@grid_size, true).join(make_divider_line(@grid_size))
  end

  def full?
    # nil returns a falsey value, so if none of the squares are nil
    # the block passed to .all? will return true each time
    # so the entire line will return true if board is full (no nil)
    @squares.all?{ |square| square.mark }
  end

  def complete_row?(marker)
    horizontal_row?(marker) || diagonal_row?(marker) || vertical_row?(marker)
  end

  private

  def find_unmarked
    # return an array of integers that represent which squares still have a 
    # status of nil (index + 1)
    unmarked_squares = []
    @squares.each_with_index do |square, idx|
      unmarked_squares << (idx + 1) unless square.mark
    end
    unmarked_squares
  end

  def find_horizontals
    horizontals = []
    row = []
    @squares.each_with_index do |_, idx|
      row << idx
      if row.size == @grid_size
        horizontals << row
        row = []
      end
    end
    horizontals
  end

  def find_diagonals
    first = []
    second = []
    diagonals = [first, second]
    counter = 0
    @horizontals.each do |row|
      first << row[counter]
      second << row.reverse[counter]
      counter += 1
    end
    diagonals
  end

  def find_verticals
    verticals = []
    vertical = []
    (0...@grid_size).each do |index|
      @horizontals.each do |row|
        vertical << row[index]
      end
      verticals << vertical
      vertical = []
    end
    verticals
  end

  def make_squares(n)
    squares = []
    number_of_squares = n * n
    number_of_squares.times do
      squares << Square.new
    end
    squares
  end

  def horizontal_row?(marker)
    @horizontals.any? do |row|
      row.all?{ |index| @squares[index].mark == marker}
    end
  end

  def diagonal_row?(marker)
    @diagonals.any? do |row|
      row.all?{ |index| @squares[index].mark == marker}
    end
  end

  def vertical_row?(marker)
    @verticals.any? do |row|
      row.all?{ |index| @squares[index].mark == marker}
    end
  end

  def make_active_lines(n=@grid_size, reference=false) # embeds active objects in the string representation
    active_lines = [] # a string of active lines
    counter = 0
    n.times do
      active_line = []
      n.times do
        r_marker = @squares[counter].mark ? " " : (counter + 1)
        marker = reference ? r_marker : @squares[counter]
        active_line << " #{marker} "
        counter += 1
      end
      active_lines << active_line.join("|")
    end
    active_lines
  end
  
  def make_divider_line(n=@grid_size) # does not hold any active data
    divider_line = []
    n.times do
      divider_line << "---"
    end
    "\n#{divider_line.join("+")}\n"
  end
end

### ENGINE CLASS
class TTTGame
  BANNER_SIZE = 70
  MARKERS = ['x', 'o']
  MAX_POINTS = 5
  MIN_BOARD_SIZE = 3
  MAX_BOARD_SIZE = 5
  BOARD_RANGE = (MIN_BOARD_SIZE..MAX_BOARD_SIZE).to_a

  attr_accessor :board, :player1, :player2, :current_player

  def initialize
    @board = nil # Board.new(3) # keeps track of board state
    @player1 = nil
    @player2 = nil
    @winner = nil
    @round = 1
    @champion = nil
  end

  def play
    display_welcome_message
    set_game_parameters
    loop do # New Game Loop
      loop do # Turn-taking loop
        board.display(@board.size, heading)
        @current_player.choose_square(board)
        board.display(@board.size, heading)
        break if board.full? || winner_exists?
        @current_player = next_player
      end # End Turn
      display_outcome
      increment_points
      @round += 1
      break if game_over? || quit?
      reset
    end
    display_goodbye_message
  end

  private

  def heading
    Banner.new(["Round #{@round}",
                "#{player1.name} (#{player1.marker}) VS " +
                "#{player2.name} (#{player2.marker})",
                "#{@current_player.name}'s turn."],
                BANNER_SIZE)
  end

  def increment_points
    @winner.points += 1 if @winner
  end

  def reset
    @board = Board.new(board.size)
    @winner = nil
    @current_player = @player1
  end

  def next_player
    current_player == @player1 ? @player2 : @player1
  end

  def game_over?
    if @player1.points >= MAX_POINTS 
      @champion = @player1
    elsif @player2.points >= MAX_POINTS
      @champion = @player2
    end
    !!@champion
  end

  def quit?
    puts "Ready for Round #{@round}? ('Q' to quit)."
    answer = gets.chomp.upcase
    answer == 'Q'
  end

  def display_welcome_message
    puts Banner.new("WELCOME TO TICTACTOE", BANNER_SIZE)
  end

  def set_game_parameters
    ask_player_mode
    ask_board_size
    @current_player = @player1
  end

  def ask_player_mode
    puts "How many players (1 or 2)?"
    number_of_players = gets.chomp.to_i
    loop do 
      break if [1, 2].include?(number_of_players)
      puts "Sorry, please enter 1 or 2."
      number_of_players = gets.chomp.to_i
    end
    initialize_players(number_of_players)
  end

  def initialize_players(player_mode)
    puts Banner.new("PLAYER 1", BANNER_SIZE)
    self.player1 = Human.new
    set_marker(player1)
    puts Banner.new("PLAYER 2", BANNER_SIZE)
    self.player2 = player_mode == 2 ? Human.new : Computer.new
    set_marker(player2, player1.marker)
  end

  def set_marker(player, taken_marker=nil)
    if taken_marker
      other_marker = MARKERS.reject{|m| m == taken_marker}.first
      player.marker = other_marker
    else
      puts "Would you like to play as #{MARKERS.first} or #{MARKERS.last}?"
      marker = gets.chomp
      loop do
        break if MARKERS.include?(marker)
        puts "Sorry, please choose a valid marker."
        marker = gets.chomp
      end
      player.marker = marker
    end
  end

  def ask_board_size
    puts "What size board would you like to play with?"
    size = gets.chomp.to_i
    loop do
      break if BOARD_RANGE.include?(size)
      puts "Sorry please enter a value between #{MIN_BOARD_SIZE} and " +
           "#{MAX_BOARD_SIZE}."
      size = gets.chomp.to_i
    end
    self.board = Board.new(size)
  end

  def winner_exists?
    if board.complete_row?(player1.marker)
      @winner = player1
    elsif board.complete_row?(player2.marker)
      @winner = player2
    end
    !!@winner
  end

  def display_outcome
    outcome = winner_exists? ? "#{@winner.name.upcase} WINS!" : "BOARD FULL. IT'S A TIE."
    puts Banner.new(outcome, BANNER_SIZE)
  end

  def display_goodbye_message
    message = ''
    if game_over?
      message = "#{@champion.name.upcase} WINS THE GAME."
    else
      message = "Sorry to see you go so soon!"
    end
    puts Banner.new(['~ * GAME OVER * ~', 
                     'SCORES', 
                     "#{player1.name}\t#{player1.points}",
                     "#{player2.name}\t#{player2.points}",
                      message, 
                     "Thank you for playing! Goodbye."], BANNER_SIZE)
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
  end # End play_again?
end # End TTTGame Class

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

game = TTTGame.new
game.play

