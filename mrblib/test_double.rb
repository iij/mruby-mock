module Mocks
  module TestDouble
#    attr_reader :mocks
    def initialize
      $_mruby_mock_expectations ||= { }
    end

    def self.extended(instance)
      instance.instance_eval do
        def method_missing(name, *args, &block)
          if $_mruby_mock_expectations[self]
            $_mruby_mock_expectations[self][name][:invoked] = true

            hash = { :expected_args => $_mruby_mock_expectations[self][name][:with] == args }
            hash[:expected_args] = true if args.empty? && $_mruby_mock_expectations[self][name][:with].nil?
            hash[:args] = args
            $_mruby_mock_expectations[self][name][:history] << hash

            return $_mruby_mock_expectations[self][name][:returns]
          else
            super
          end
        end
      end
    end

    def stubs(method)
      $_mruby_mock_expectations ||= { }
      $_mruby_mock_expectations[self] ||= { }
      $_mruby_mock_expectations[self][method] ||= Mocks::Expectation.new

      unless self.class == Mocks::Mock
        self.class.class_eval do
          if method_defined?(method)
            alias_method "original_#{method}".to_sym, method
            undef_method(method)
          end
        end
      end
      $_mruby_mock_expectations[self][method].add_stub(method)

    end

    def original_method(method)
      self.send("original_#{method}")
    end

    def method_missing(name, *args, &block)
      if $_mruby_mock_expectations[self]
        $_mruby_mock_expectations[self][name][:invoked] = true

        hash = { :expected_args => $_mruby_mock_expectations[self][name][:with] == args }
        hash[:expected_args] = true if args.empty? && $_mruby_mock_expectations[self][name][:with].nil?
        hash[:args] = args
        $_mruby_mock_expectations[self][name][:history] << hash

        hash[:expected_args] && $_mruby_mock_expectations[self][name][:returns]
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
