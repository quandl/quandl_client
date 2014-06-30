class Quandl::Client::Base
  module Benchmark

    extend ActiveSupport::Concern

    included do
      benchmark(:save)
    end

    module ClassMethods
      def benchmark(*names)
        names.each do |name|
          def_benchmark(name)
        end
      end

      private

      def def_benchmark(name)
        define_method(name) do |*args, &block|
          benchmark(name) do
            super(*args, &block) if defined?(super)
          end
        end
      end
    end

    def human_benchmarks
      benchmarks.sort_by{|k,v| v }.reverse.collect{|k,v| "#{k}: #{v.microseconds}ms" }.join(' | ')
    end

    def benchmarks
      @benchmarks ||= {}
    end

    private

    def benchmark(name, &block)
      timer = Time.now
      result = block.call
      self.benchmarks[name.to_sym] ||= timer.elapsed
      result
    end

  end
end