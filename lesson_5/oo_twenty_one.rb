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
class Participant
  attr_accessor :hand, :stayed
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

    # adjust for aces
    if has_ace? && total > 21
      aces = count_ace
      until total <= 21 || aces == 0
        total -= 10
        aces -= 1
      end
    end
    total
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
end

class Dealer < Participant
  def initialize
    super()
  end

  def hit_or_stay
    total >= 17 ? "stay" : "hit"
  end

  def display_hand
    puts "Dealer has #{hand.first} and #{hand.size - 1} other card(s)."
  end
  
  def to_s
    "Dealer"
  end
end

class Player < Participant
  def initialize
    super()
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
    # ask to hit or stay
    # return a string
  end

  def display_hand
    s_hand = @hand.map{ |card| card.to_s}.join(", ")
    puts "You have #{s_hand}."
    puts ""
    puts "Your total is #{total}."
    # You have __, ___, ___
    # For a total of ___
  end

  def to_s
    "Player"
  end
end

class Deck
  SUITS = ['Hearts', 'Spades', 'Clubs', 'Diamonds']
  CARD_TYPE = ['Ace', 'Two', 'Three', 'Four', 'Five', 'Six',
               'Seven', 'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King']
  def initialize
    @cards = []
    get_cards
  end

  def deal(participant)
    dealt_card = @cards.sample
    participant.hand << dealt_card
    @cards = @cards.reject{ |card| card == dealt_card}
    #removes a card from the deck and places it in hand of participant
  end

  def to_s
    list = @cards.map do |card|
            card.to_s
          end
    "#{list}"
  end

  def size
    @cards.size
  end

  private

  def get_cards
    SUITS.each do |suit|
      CARD_TYPE.each do |type|
        @cards << Card.new(type, suit)
      end
    end
  end

end

class Card
  attr_reader :name, :suit, :value

  def initialize(name, suit)
    @suit = suit
    @name = name
    @value = get_value
  end

  def +(other)
    if other.is_a?(Integer)
      self.value + other
    else
      self.value + other.value
    end
  end

  def to_s
    "#{name} of #{suit}"
  end

  def ==(other_card)
    name == other_card.name && suit == other_card.suit
  end

  private

  def get_value
    case name
      when 'Ace' then 11
      when 'Two' then 2
      when 'Three' then 3
      when 'Four' then 4
      when 'Five' then 5
      when 'Six' then 6
      when 'Seven' then 7
      when 'Eight' then 8
      when 'Nine' then 9
      else 10
    end
  end
end

class Game
  attr_accessor :player, :dealer, :deck, :winner
  def initialize 
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @winner = nil
  end

  def start
    system("clear")
    deal_initial_cards
    show_initial_cards
    loop do
      # refactor this because the repetition is annoying me
      player_turn
      break @winner = @dealer if @player.bust?
      dealer_turn
      break @winner = @player if @dealer.bust?
      break if @player.stayed && @dealer.stayed
    end
    show_result
  end

  private

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
    puts "#{@winner} wins with a total of #{@winner.total}!"
    # show both cards?
  end # end show_result
end # end Game Class

# 
game = Game.new
game.start
