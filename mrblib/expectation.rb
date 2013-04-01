module Mocks
  class Expectation < Hash
    def add_stub(expected_method)
      self[:method] = expected_method
      self[:count] = 0

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

  end
end
