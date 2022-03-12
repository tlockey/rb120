BANNER_SIZE = 80

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
end # end Player class

### HUMAN CLASS

class Human < Player
  def initialize
    super()
    ask_name
  end

  def choose_square(board)
    board.display_available
    puts "Please pick an available square."
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
    threat_threshold = board.size / 2
    lines = board.horizontals + board.verticals + board.diagonals
    selection = offense(board, threat_threshold, lines)
    unless !!selection
      selection = defense(board, threat_threshold, lines)
    end
    unless !!selection
      selection = board.unmarked.sample
    end
    board.mark_square(selection, marker)
  end

  def offense(board, threat_threshold, lines)
    lines.each do |line| # an array of indexes of squares
      next unless empty_square?(board, line)
      marked = 0
      line.each do |idx|
        marked += 1 if board.squares[idx].mark == marker
      end
      return find_empty(board, line) if marked > threat_threshold
    end
    nil
  end

  def defense(board, threat_threshold, lines)
    lines.each do |line| # an array of indexes of squares
      next unless empty_square?(board, line)
      marked_by_other = 0
      line.each do |idx|
        marked_by_other += 1 if not_computer(board, idx)
      end
      return find_empty(board, line) if marked_by_other > threat_threshold
    end
    nil
  end

  def empty_square?(board, line)
    line.each do |idx|
      return true if board.squares[idx].mark.nil?
    end
    false
  end

  def not_computer(board, idx)
    mark = board.squares[idx].mark
    !mark.nil? && mark != marker
  end

  def find_empty(board, line)
    line.each do |idx|
      return (idx + 1) if board.squares[idx].mark.nil?
    end
  end
end

### SQUARE CLASS

class Square
  attr_accessor :mark

  def initialize
    @mark = nil
  end

  def to_s
    !!@mark ? @mark : " "
  end
end

class Board
  attr_accessor :unmarked, :horizontals, :diagonals, :verticals
  attr_reader :squares

  def initialize(n)
    @grid_size = n
    @squares = make_squares(@grid_size)
    @unmarked = find_unmarked
    # returns lines as nested array of indexes
    @horizontals = find_horizontals # [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
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

  def display(heading=nil)
    system('clear')
    puts heading unless heading.nil?
    puts Banner.new(get_grid_array, BANNER_SIZE)
  end

  def display_available
    grid = get_grid_array(numbered: true)
    heading = ["AVAILABLE SQUARES", " "]
    puts Banner.new(heading + grid, BANNER_SIZE)
  end

  def full?
    @squares.all?(&:mark)
  end

  def complete_row?(marker)
    horizontal_row?(marker) || diagonal_row?(marker) || vertical_row?(marker)
  end

  private

  def get_grid_array(numbered=false)
    grid_array = []
    active_lines = numbered ? make_reference_lines : make_active_lines
    divider_lines = [make_divider_line(numbered)] * (size - 1)

    # interleaving active and divider lines:
    size.times do
      grid_array << active_lines.shift
      grid_array << divider_lines.shift unless divider_lines.empty?
    end
    grid_array
  end

  def make_reference_lines
    space = big_board? ? "  " : " "
    @horizontals.map do |row|
      row.map do |idx|
        number = big_board? ? format("%2d", (idx + 1)) : (idx + 1)
        marker = @squares[idx].mark ? space : number
        " #{marker} "
      end.join("|")
    end # return an array of str of rows with numbers
  end

  def big_board?
    size > 3
  end

  def make_active_lines
    @horizontals.map do |row|
      row.map { |idx| " #{@squares[idx]} " }.join("|")
    end
  end

  def make_divider_line(numbered=false)
    divider = numbered && size > 3 ? "----" : "---"
    divider_line = []
    size.times do
      divider_line << divider
    end
    divider_line.join('+')
  end

  def find_unmarked
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
      row.all? { |index| @squares[index].mark == marker }
    end
  end

  def diagonal_row?(marker)
    @diagonals.any? do |row|
      row.all? { |index| @squares[index].mark == marker }
    end
  end

  def vertical_row?(marker)
    @verticals.any? do |row|
      row.all? { |index| @squares[index].mark == marker }
    end
  end
end

### ENGINE CLASS
class TTTGame
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
      player_turn # loop
      end_round
      break if game_over? || quit?
      reset
    end
    display_goodbye_message
  end

  private

  def player_turn
    loop do
      board.display(heading)
      @current_player.choose_square(board)
      board.display(heading)
      break if board.full? || winner_exists?
      @current_player = next_player
    end
  end

  def end_round
    display_outcome
    increment_points
    @round += 1
  end

  def heading
    Banner.new(["Round #{@round}",
                "#{player1.name} (#{player1.marker}) VS " \
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
    system("clear")
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
    system('clear')
    puts Banner.new("PLAYER 1", BANNER_SIZE)
    self.player1 = Human.new
    set_marker(player1)
    system('clear')
    puts Banner.new("PLAYER 2", BANNER_SIZE)
    self.player2 = player_mode == 2 ? Human.new : Computer.new
    set_marker(player2, player1.marker)
  end

  def set_marker(player, taken_marker=nil)
    if taken_marker
      other_marker = MARKERS.reject { |m| m == taken_marker }.first
      player.marker = other_marker
    else
      player.marker = ask_for_marker
    end
  end

  def ask_for_marker
    puts "Would you like to play as #{MARKERS.first} or #{MARKERS.last}?"
    marker = gets.chomp
    loop do
      break if MARKERS.include?(marker)
      puts "Sorry, please choose a valid marker."
      marker = gets.chomp
    end
    marker
  end

  def ask_board_size
    system('clear')
    puts "What size board would you like to play with? " \
         "(Enter a number between #{MIN_BOARD_SIZE} and #{MAX_BOARD_SIZE})"
    size = gets.chomp.to_i
    until BOARD_RANGE.include?(size)
      puts "Sorry please enter a value between #{MIN_BOARD_SIZE} and " \
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
    winner = @winner ? @winner.name.upcase : "NO ONE"
    outcome_messages = ["#{winner} WINS!",
                        "BOARD FULL. IT'S A TIE."]
    outcome = winner_exists? ? outcome_messages.first : outcome_messages.last
    puts Banner.new(outcome, BANNER_SIZE)
  end

  def display_goodbye_message
    champ = @champion ? @champion.name.upcase : "NO ONE"
    message_opt = ["#{champ} WINS THE GAME.", "Sorry to see you go so soon!"]
    message = game_over? ? message_opt.first : message_opt.last
    player1_score = format("%3d", player1.points)
    player2_score = format("%3d", player2.points)
    puts Banner.new(['~ * GAME OVER * ~', 'SCORES',
                     "#{player1.name}#{player1_score}",
                     "#{player2.name}#{player2_score}",
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
    @message = message.is_a?(Array) ? message : [message]
    @size = size.nil? ? message.map(&:size).max : size
  end

  def to_s
    ([horizontal_rule, empty_line] +
      message_line +
      [empty_line, horizontal_rule]).join("\n")
  end

  private

  DASH = '-'
  SPACE = ' '

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
