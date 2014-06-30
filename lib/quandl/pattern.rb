module Quandl
  class Pattern < Regexp

    class << self

      def define_pattern(name, pattern, options={})
        assert_unique_pattern!(name, pattern)
        patterns << name
        define_singleton_method(name){ Quandl::Pattern.new( pattern, options ) }
      end

      def assert_unique_pattern!(name, pattern)
        return false unless self.respond_to?(name)
        message = "Attempted to redefine previously defined pattern! '#{name}', /#{pattern}/"
        raise ArgumentError.new(name), message
      end

      def patterns
        @patterns ||= []
      end

    end

    def initialize(*args)
      @options = args.pop if args.last.is_a?(Hash)
      super(*args)
    end

    def to_example
      options[:example]
    end

    def options
      @options ||= {}
    end

  end
end