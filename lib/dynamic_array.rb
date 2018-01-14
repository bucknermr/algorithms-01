require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity = 8
    @store = StaticArray.new(8)
    @length = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" unless check_index(index)
    store[index]
  end

  # O(1)
  def []=(index, value)
    raise "index out of bounds" unless check_index(index)
    store[index] = value
  end

  # O(1)
  def pop
    raise 'index out of bounds' if length == 0
    @length -= 1
    store[length]
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if length == capacity
    store[length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise 'index out of bounds' if length == 0
    shifted = store[0]
    1.upto(length) { |i| store[i - 1] = store[i] }
    @length -= 1
    shifted
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if length == capacity
    length.downto(1) { |i| store[i] = store[i - 1] }
    store[0] = val
    @length += 1
  end

  protected

  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    length > index
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    self.capacity *= 2
    new_store = StaticArray.new(capacity)
    length.times { |i| new_store[i] = store[i] }
    self.store = new_store
  end
end
