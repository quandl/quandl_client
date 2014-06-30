class Quandl::Client::Dataset
  module Benchmark
    extend ActiveSupport::Concern

    included do
      benchmark :data_should_be_valid!, :source_code_should_exist!, :save_dataset_data, :enforce_required_formats, :valid?
    end

  end
end