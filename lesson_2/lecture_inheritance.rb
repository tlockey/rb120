### ONE
# class Dog
#   def speak
#     'bark!'
#   end

#   def swim
#     'swimming!'
#   end
# end

# class Bulldog < Dog
#   def swim
#     "can't swim!"
#   end
# end
# teddy = Dog.new
# puts teddy.speak           # => "bark!"
# puts teddy.swim           # => "swimming!"

# jeff = Bulldog.new
# puts jeff.speak
# puts jeff.swim

### TWO
# class Animal
#   def speak(sound)
#     sound
#   end

#   def run
#     'running!'
#   end

#   def jump
#     'jumping!'
#   end

# end

# class Dog < Animal
#   def speak
#     super('bark')
#   end

#   def swim
#     'swimming!'
#   end

#   def fetch
#     'fetching!'
#   end

# end

# class Cat < Animal
#   def speak
#     super('meow')
#   end
# end

# p Cat.new.speak

# p Cat.new.jump

### THREE
# Animal > Cat
#        > Dog > Bulldog

### FOUR
# Method lookup path is where and the order in which ruby looks for methods
# It's important because the order influences how a method is implemented.
