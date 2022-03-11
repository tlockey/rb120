### ONE
# class Person
#   attr_accessor :name
#   def initialize(name)
#     @name = name
#   end
# end

# bob = Person.new('bob')
# p bob.name                  # => 'bob'
# p bob.name = 'Robert'
# p bob.name                  # => 'Robert'

### TWO
# class Person
#   attr_accessor :last_name
#   attr_reader :first_name

#   def initialize(first_name, last_name='')
#     @first_name = first_name
#     @last_name = last_name
#   end

#   def name
#     first_name + ' ' + last_name
#   end
# end

# bob = Person.new('Robert')
# p bob.name                  # => 'Robert'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# p bob.last_name = 'Smith'
# p bob.name                  # => 'Robert Smith'

### THREE

# class Person
#   attr_accessor :first_name, :last_name
#   def initialize(name)
#     parts = name.split
#     @first_name = parts[0]
#     @last_name = parts.size > 1 ? parts.last : ''
#   end

#   def name
#     "#{first_name} #{last_name}".strip
#   end

#   def name=(name)
#     parts = name.split
#     @first_name = parts.first
#     @last_name = parts.size > 1 ? parts.last : @last_name
#   end
# end

# bob = Person.new('Robert')
# p bob.name                  # => 'Robert'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# p bob.last_name = 'Smith'
# p bob.name                  # => 'Robert Smith'

# p bob.name = "John Adams"
# p bob.first_name            # => 'John'
# p bob.last_name             # => 'Adams'

### FOUR + Refactoring from THREE:

class Person
  attr_accessor :first_name, :last_name
  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end
  private
  
  def parse_full_name(full_name)
    parts = name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name
