=begin
Twenty One is a card game with a dealer and a player.
There is a deck of cards composed of 52 cards.
There are 4 suits (hearts, diamonds, clubs and spades),
And 13 values, (2, 3, 4, 5 ,6, 7, 8, 9, 10, jack, queen, king, ace)

The goal is to get as close to 21 as possible withhout going over.
Going over 21 is a bust and you lose.

Both participants are dealt 2 cards.
The player can see 2 cards, but only one of the dealer's cards.

Ace's value is determined every time a new card is drawn from the deck

nouns
- participant
  - dealer
  - player
    - has a hand
    - can hit or stay
    -

deck (object that holds 52 card objects)?
cards
  - suit
  - name
  - value
    - 2 - 10 -> 10
    - jack, queen, king -> 10
    - ace, 1 or 11

verbs/actions:
deal cards
determine value of ace/other cards
get the sum of hand
ace.value(hand)
----
participant
  - @hand

dealer
  - hit?
    - check if sum of hand is 17 or more
    - return true if so

deck
  - a container for card objects?
  - deck.new
card
  - @suit
  - @name
  - @value
  - jack + ace
  - .+(other_card) method
  - to_s:
    @name + 'of' + @suit
  - ==(other)
    @name and @suit match
ace < card
if there is an ace, adjust for ace ?

IMPROVEMENTS:

[ ] General Refactoring
[ ] General UX Improvements
    [ ] Display both player's cards at the end ?
    [ ] Improve Display Player Cards to have and,
[ ] Create a Proper Map
    [ ] Test Individual Parts

=end
require 'pry'
module Displayable
  BANNER_SIZE = 80

  def display(message)
    puts Banner.new(message, BANNER_SIZE)
  end

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
end

class Participant
  include Displayable
  attr_accessor :hand, :stayed, :name

  def initialize
    @hand = []
    @stayed = false
  end

  def bust?
    total > 21 # calls method total which returns an integer
  end

  def total
    total = 0
    @hand.each do |card|
      total = card + total
    end

    total = adjust_for_aces(total)
  end

  def adjust_for_aces(total)
    if has_ace? && total > 21
      aces = count_ace
      until total <= 21 || aces == 0
        total -= 10
        aces -= 1
      end
    end
    total
  end

  def display_hand
    list = ["---#{name}'s hand---"]
    @hand.each do |card|
      list << "=> #{card}"
    end
    list << "Total => #{total}."
    display(list)
  end

  private

  def has_ace?
    @hand.each do |card|
      return true if card.name == "Ace"
    end
    false
  end

  def count_ace
    aces = 0
    @hand.each do |card|
      aces += 1 if card.name == "Ace"
    end
    aces
  end

  def to_s
    name
  end
end

class Dealer < Participant
  NAMES = %w(Holly Joe Spencer Tracey John)

  def initialize
    super()
    @name = NAMES.sample
  end

  def hit_or_stay
    total >= 17 ? "stay" : "hit"
  end

  def display_hand(hidden=true)
    if hidden
      display_first_card
    else
      super()
    end
  end

  def display_first_card
    list = ["---#{name}'s hand---"]
    list << "=> #{hand.first}"
    (hand.size - 1).times do
      list << "=> ??? "
    end
    display(list)
  end

  def to_s
    "Dealer"
  end
end

class Player < Participant
  def initialize
    super()
    @name = ask_name
  end

  def ask_name
    puts "What's your name?"
    name = gets.chomp
    loop do
      break unless name == ""
      puts "Please enter a name."
      name = gets.chomp
    end
    name
  end

  def hit_or_stay
    puts "Do you want to hit or stay?"
    choice = gets.chomp.downcase
    loop do
      break if ["hit", "stay"].include?(choice)
      puts "Sorry, invalid choice. Hit or Stay?"
      choice = gets.chomp.downcase
    end
    choice
  end
end

class Deck
  def initialize
    @cards = []
    make_deck
  end

  def deal(participant)
    participant.hand << @cards.pop
  end

  def to_s
    list = @cards.map(&:to_s)
    list
  end

  def size
    @cards.size
  end

  private

  def make_deck
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(face, suit)
      end
    end
    @cards.shuffle!
  end
end

class Card
  SUITS = ['Hearts', 'Spades', 'Clubs', 'Diamonds']
  FACES = ['Ace', 'Two', 'Three', 'Four', 'Five', 'Six',
           'Seven', 'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King']
  VALUES = { 'Ace' => 11, 'Two' => 2, 'Three' => 3, 'Four' => 4,
             'Five' => 5, 'Six' => 6, 'Seven' => 7, 'Eight' => 8,
             'Nine' => 9, 'Ten' => 10, 'Jack' => 10, 'Queen' => 10,
             'King' => 10 }

  attr_reader :name, :suit, :value

  def initialize(name, suit)
    @suit = suit
    @name = name
    @value = VALUES[name]
  end

  def +(other)
    if other.is_a?(Integer)
      value + other
    else
      value + other.value
    end
  end

  def to_s
    "#{name} of #{suit}"
  end

  def ==(other_card)
    name == other_card.name && suit == other_card.suit
  end
end

class Game
  include Displayable

  attr_accessor :player, :dealer, :deck, :winner

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @winner = nil
  end

  def start
    system("clear")
    display_welcome_message
    deal_initial_cards
    show_initial_cards
    game_body
    show_result
  end

  private

  def game_body
    loop do
      player_turn
      break @winner = @dealer if @player.bust?
      dealer_turn
      break @winner = @player if @dealer.bust?
      break if @player.stayed && @dealer.stayed
    end
  end

  def display_welcome_message
    display(["Welcome to Twenty-One!",
             "Press ENTER to deal initial cards."])
    gets.chomp
  end

  def deal_initial_cards
    2.times do
      @deck.deal(player)
      @deck.deal(dealer)
    end
  end

  def show_initial_cards
    player.display_hand
    dealer.display_hand
  end

  def player_turn
    choice = player.hit_or_stay
    if choice == "hit"
      deck.deal(player)
      puts "You chose to hit."
      player.display_hand
    elsif choice == "stay"
      player.stayed = true
      puts "You chose to stay."
    end
  end # end player_turn

  def dealer_turn
    choice = dealer.hit_or_stay
    if choice == "hit"
      deck.deal(dealer)
      puts "Dealer chose to hit."
      dealer.display_hand
    elsif choice == "stay"
      dealer.stayed = true
      puts "Dealer chose to stay."
    end
  end # end dealer_turn

  def show_result
    unless winner
      @winner = dealer.total > player.total ? dealer : player
    end
    system("clear")
    display("GAME OVER")
    player.display_hand
    dealer.display_hand(false)
    display("#{@winner} wins with a total of #{@winner.total}!")
  end # end show_result
end # end Game Class

game = Game.new
game.start
