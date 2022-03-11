=begin
### THE OBJECT MODEL

module Speak
  def speak(sound)
    puts sound
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!")

bob = HumanBeing.new
bob.speak("Hello!")

puts "---GoodDog ancestors---"
puts GoodDog.ancestors
puts ''
puts "---HumanBeing ancestors---"
puts HumanBeing.ancestors

## EXERCISES

module Eat
	def eat(quantity)
		puts "#{'nom' * quantity}. All done."
	end
end

class ChickenNuggets 
	include Eat
end
nuggies = ChickenNuggets.new
nuggies.eat(3) #=> "nomnomnom. All done."

=end

### CLASSES AND OBJECTS I

# class GoodDog
#   def initialize(name)
#     @name = name # instance variable
#   end

#   def speak
#     "#{@name} says Arf!"
#   end

#   def name
#     @name
#   end

#   def name=(name) #hmm this syntax is a bit interesting
#     @name = name
#   end
# end

# sparky = GoodDog.new("Sparky")
# fido = GoodDog.new("Fido")

# puts sparky.speak
# puts fido.speak

# puts sparky.name
# puts sparky.name = "Spartacus"
# puts sparky.name

# refactoring class GoodDog:

# class GoodDog
#   attr_accessor :name
#   def initialize(name)
#     @name = name
#   end

#   def speak
#     # "#{@name} says Arf!"
#     "#{name} says Arf!" # calling the getter method is better 
#   end
# end

# sparky = GoodDog.new("Sparky")
# puts sparky.name
# puts sparky.name = "Spartacus"
# puts sparky.name

## EXERCISES 

# class MyCar
# 	attr_accessor :speed, :color, :model
# 	attr_reader :year

# 	def initialize(y, c, m)
# 		self.speed = 0
# 		@year = y
# 		self.color = c
# 		self.model = m
# 	end

# 	def speed_up(s)
# 		self.speed += s
# 		"You're going #{speed} mph!"
# 	end
	
# 	def brake(b)
# 		self.speed -= b
# 		"Braking. Your speed is now #{speed}."
# 	end
	
# 	def shut_off
# 		self.speed = 0
# 		"Car is turned off."
# 	end

#   def spray_paint(color)
#     old_color = self.color
#     self.color = color
#     puts "Your car was #{old_color}, but it's now #{color}."
#   end
# end

# suzuki = MyCar.new('2017', 'blue', 'suzuki')
# p suzuki.year
# p suzuki.color = 'black'
# p suzuki.year
# p suzuki.model
# p suzuki.speed
# p suzuki.speed_up(23)
# p suzuki.speed_up(5)
# p suzuki.speed
# p suzuki.brake(23)
# p suzuki.shut_off
# p suzuki.spray_paint('blue')

### CLASSES AND OBJECTS PART II

## CLASS METHODS, CLASS VARIABLES

# class GoodDog
#   @@number_of_dogs = 0 # class variable

#   def initialize
#     @@number_of_dogs += 1
#   end

#   def self.total_number_of_dogs # class method
#     @@number_of_dogs
#   end

#   def self.what_am_i
#     "I'm a GoodDog class!"
#   end
# end

# p GoodDog.what_am_i

# puts GoodDog.total_number_of_dogs

# dog1 = GoodDog.new
# dog2 = GoodDog.new

# puts GoodDog.total_number_of_dogs

## CONSTANTS

# class GoodDog
#   DOG_YEARS = 7
#   attr_accessor :name, :age

#   def initialize(n, a)
#     self.name = n
#     self.age = a * DOG_YEARS
#   end

#   def to_s
#     "This Dog's name is #{name} and it is #{age} in dog years."
#   end
# end

# sparky = GoodDog.new("Sparky", 4)
# puts sparky.age

# puts sparky

## SELF

# class GoodDog
#   attr_accessor :name, :height, :weight

#   def initialize(n, h, w)
#     self.name = n
#     self.height = h
#     self.weight = w
#   end

#   def change_info(n, h, w)
#     self.name = n
#     self.height = h
#     self.weight = w
#   end

#   def info
#     "#{self.name} weighs #{self.weight} and is #{self.height} tall."
#   end

#   def what_is_self
#     self
#   end
# end

# sparky = GoodDog.new('Sparky', '12 inches', '10lbs')
# p sparky.what_is_self

## EXERCISES

# class MyCar
# 	attr_accessor :speed, :color, :model
# 	attr_reader :year

# 	def initialize(y, c, m)
# 		self.speed = 0
# 		@year = y
# 		self.color = c
# 		self.model = m
# 	end

# 	def speed_up(s)
# 		self.speed += s
# 		"You're going #{speed} mph!"
# 	end
	
# 	def brake(b)
# 		self.speed -= b
# 		"Braking. Your speed is now #{speed}."
# 	end
	
# 	def shut_off
# 		self.speed = 0
# 		"Car is turned off."
# 	end

#   def spray_paint(color)
#     old_color = self.color
#     self.color = color
#     puts "Your car was #{old_color}, but it's now #{color}."
#   end

#   def self.gas_mileage(miles, gallons)
#     puts "#{miles / gallons} miles per gallon"
#   end

#   def to_s
#     "This car is a #{color} #{model} #{year}."
#   end
# end

# suzuki = MyCar.new('2010', 'blue', 'suzuki')
# MyCar.gas_mileage(356, 12)
# puts suzuki

### INHERITANCE

## CLASS INHERITANCE

## EXERCISES

# module Ridable
#   def ride
#     "You get in and go."
#   end
# end

# class Vehicle
#   attr_accessor :speed, :color
# 	attr_reader :year, :model, :vehicle_type
#   @@number_of_vehicles = 0

#   def initialize(vehicle_type, year, color, model)
#     @vehicle_type = vehicle_type
#     @year = year
#     @model = model
#     self.color = color
#     self.speed = 0
#     @@number_of_vehicles += 1
#   end

#   def self.number_of_vehicles
#     @@number_of_vehicles
#   end

#   def speed_up(s)
# 		self.speed += s
# 		"You're going #{speed} mph!"
# 	end

#   def brake(b)
# 		self.speed -= b
# 		"Braking. Your speed is now #{speed}."
# 	end
	
# 	def shut_off
# 		self.speed = 0
# 		"Your #{vehicle_type} is turned off."
# 	end

#   def self.gas_mileage(miles, gallons)
#     puts "#{miles / gallons} miles per gallon"
#   end

#   def spray_paint(color)
#     old_color = self.color
#     self.color = color
#     puts "Your #{vehicle_type} was #{old_color}, but it's now #{color}."
#   end

#   def to_s
#     "This #{vehicle_type} is a #{color} #{model} #{year}."
#   end

#   def age
#     "This #{vehicle_type} is #{get_age(year)} years old."
#   end
#   private
#   def get_age(year)
#     Time.now.year - Time.new(year).year
#   end
# end

# class MyCar < Vehicle
# include Ridable
#   NUMBER_OF_DOORS = 4
# 	def initialize(year, color, model)
#     @vehicle_type = 'car'
#     super(@vehicle_type, year, color, model)
# 	end

# end

# class MyTruck < Vehicle
#   NUMBER_OF_DOORS = 2
#   def initialize(year, color, model)
#     @vehicle_type = 'truck'
#     super(@vehicle_type, year, color, model)
#   end
# end

# tacoma = MyTruck.new('2010', 'white', 'tacoma')
# p tacoma.speed
# p tacoma.speed_up(10)
# p tacoma.speed_up(15)
# p tacoma.shut_off
# blueberry = MyCar.new('2009', 'blue', 'suzuki')
# p Vehicle.number_of_vehicles
# p blueberry.ride
# p MyCar.ancestors
# p MyTruck.ancestors
# p Vehicle.ancestors
# p blueberry.age
# p tacoma.age

class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected
  
  def grade
    @grade
  end
end

joe = Student.new('joe', 82)
bob = Student.new('bob', 80)

puts "Well done!" if joe.better_grade_than?(bob)
