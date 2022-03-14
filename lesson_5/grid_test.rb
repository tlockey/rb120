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

# # get display to return an array of strings
# def make_active_lines(n=@grid_size, reference=false) # embeds active objects in the string representation
#   active_lines = [] # a string of active lines
#   counter = 0
#   n.times do
#     active_line = []
#     n.times do
#       r_marker = @squares[counter].mark ? " " : (counter + 1)
#       marker = reference ? r_marker : @squares[counter]
#       active_line << " #{marker} "
#       counter += 1
#     end
#     active_lines << active_line.join("|")
#   end
#   active_lines
# end

# def make_divider_line(n=@grid_size) # does not hold any active data
#   divider_line = []
#   n.times do
#     divider_line << "---"
#   end
#   "\n#{divider_line.join("+")}\n"
# end

# def display(n=@grid_size, heading=nil)
#   system('clear')
#   puts heading unless heading.nil?
#   puts make_active_lines(n).join(make_divider_line(n))
# end

size = 3
active_lines = [" x |   |   ", " o | x | o ", " x | o |   "]
divider_line = "---+---+---"
divider_lines = [divider_line] * (size - 1)

grid_array = []
size.times do 
  grid_array << active_lines.shift
  grid_array << divider_lines.shift unless divider_lines.empty?
end
p grid_array
puts Banner.new(grid_array, 80)

reference = grid_array.clone
reference.unshift("AVAILABLE SQUARES")
puts Banner.new(reference, 80)

def display
  system('clear')
  puts Banner.new(get_grid_array, 80)
end

def display_available
  puts Banner.new(get_grid_array(numbered: true), 80)
end

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
  reference_lines = [] # array of strings of reference lines
  idx = 0
  size.times do
    squares = []
    size.times do 
      number = sprintf("%2d", (idx + 1))
      marker = @squares[idx].mark ? "  " : number
      squares << " #{marker} "
      idx += 1
    end
    reference_lines << squares.join("|")
  end
  reference_lines
end

def make_active_lines
  active_lines = [] # array of strings of active lines
  idx = 0
  size.times do
    spaces = []
    size.times do 
      spaces << " #{@squares[idx]} "
      idx += 1
    end
    active_lines << spaces.join("|")
  end
  active_lines
end

def make_divider_line(numbered=false)
  divider = (numbered && grid_size > 3) ? "----" : "---"
  divider_line = []
    size.times do
      divider_line << divider
    end
    "#{divider_line.join("+")}"
  end
end

# test in engine class tic tac toe v 2
def test
  # ### OFFENSE + DEFENSE TEST
  # @board = Board.new(4)
  # @player1 = Computer.new
  # @player1.marker = 'x'
  # @board.mark_square(1, 'o')
  # @board.mark_square(9, 'o')
  # @board.mark_square(3, 'x')
  # @board.mark_square(7, 'x')
  # # @board.mark_square(25, 'x')
  # @player1.choose_square(board)
  # @board.display
  # @board.display_available

  # ### DEFENSE TEST
  # @board = Board.new(3)
  # @player1 = Computer.new
  # @player1.marker = 'x'
  # @board.mark_square(1, 'o')
  # # @board.mark_square(9, 'o')
  # # @board.mark_square(25, 'o')
  # @player1.choose_square(board)
  # @board.display
  # @board.display_available

  # ## BOARD DISPLAY TEST
  # test_heading = Banner.new(["Round #{1}",
  # "Tess(x) VS " +
  # "Joey (o)",
  # "Joey's turn."],
  # BANNER_SIZE)
  # @board = Board.new(4)
  # board.mark_square(6, 'x')
  # board.mark_square(16, 'o')
  # board.display(test_heading)
  # board.display_available
end
