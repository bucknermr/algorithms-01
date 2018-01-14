# Implement a queue with #enqueue and #dequeue, as well as a #max API,
# a method which returns the maximum element still in the queue. This
# is trivial to do by spending O(n) time upon dequeuing.
# Can you do it in O(1) amortized? Maybe use an auxiliary storage structure?

# Use your RingBuffer to achieve optimal shifts! Write any additional
# methods you need.

require_relative 'ring_buffer'

class QueueWithMax
  attr_accessor :store

  def initialize
    @store = RingBuffer.new
    @max_store = RingBuffer.new
  end

  def enqueue(val)
    @store.push(val)
    enqueue_max(val)

    val
  end

  def dequeue
    val = @store.shift
    dequeue_max(val)

    val
  end

  def max
    @max_store.first
  end

  def length
    @store.length
  end

  private

  def enqueue_max(val)
    until @max_store.empty? || @max_store.last > val
      @max_store.pop
    end

    @max_store.push(val)
  end

  def dequeue_max(val)
    @max_store.shift if @max_store.first == val
  end
end