require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @start_idx = 0
    @store = StaticArray.new(8)
  end

  # O(1)
  def [](index)
    raise 'index out of bounds' unless check_index(index)
    store[(start_idx + index) % capacity]
  end

  # O(1)
  def []=(index, val)
    raise 'index out of bounds' unless check_index(index)
    store[(start_idx + index) % capacity] = val
  end

  # O(1)
  def pop
    raise 'index out of bounds' if length == 0
    popped = self[length - 1]
    @length -= 1
    popped
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    @length += 1
    self[length - 1] = val
  end

  # O(1)
  def shift
    raise 'index out of bounds' if length == 0
    shifted = self[0]
    @start_idx = (start_idx + 1) % capacity
    @length -= 1
    shifted
  end

  # O(1) ammortized
  def unshift(val)
    resize! if length == capacity
    @start_idx = (start_idx - 1) % capacity
    @length += 1
    self[0] = val
  end

  def first
    self[0]
  end

  def last
    self[@length - 1]
  end

  def empty?
    @length == 0
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    length > index
  end

  def resize!
    new_store = StaticArray.new(capacity * 2)
    length.times { |i| new_store[i] = self[i] }
    self.store = new_store
    self.capacity *= 2
    self.start_idx = 0
  end
end
