module Mocks
  class Expectation < Hash
    def add_stub(expected_method)
      self[:method] = expected_method
      self[:history] = []

      self
    end

    def returns(expected_return)
      self[:returns] = expected_return

      self
    end

    def with(*expected_args)
      self[:with] = expected_args

      self
    end

    def at_least(min)
      self[:minimum_number] = min
    end

    def at_most(max)
      self[:maximum_number] = max
    end

    def times(num)
      self[:times] = num
    end

  end
end
