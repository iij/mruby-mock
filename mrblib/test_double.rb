module Mocks
  module TestDouble
    def initialize
      @mocks = { }
    end

    def self.extended(instance)
      instance.instance_eval do
        def method_missing(name, *args, &block)
          if @mocks[name]
            @mocks[name][:invoked] = true
            @mocks[name][:expected_args] = @mocks[name][:with] == args
            @mocks[name][:count] += 1

            return @mocks[name][:returns]
          else
            super
          end
        end
      end
    end

    def stubs(method)
      @mocks ||= { }
      @mocks[method] ||= Mocks::Expectation.new

      unless self.class == Mocks::Mock
        self.class.class_eval do
          if method_defined?(method)
            alias_method :"original_#{method}".to_sym, method
            undef_method(method)
          end
        end
      end

      @mocks[method].add_stub(method)

    end

    def original_method(method)
      self.send("original_#{method}")
    end

    def method_missing(name, *args, &block)
      if @mocks[name]
        @mocks[name][:invoked] = true
        @mocks[name][:expected_args] = @mocks[name][:with] == args
        @mocks[name][:count] += 1

        return @mocks[name][:returns]
      else
        super
      end
    end

  end

end

BasicObject.class_eval do
  def mocks
    mock = self.new.instance_eval { self.extend ::Mocks::TestDouble }
  end
end
