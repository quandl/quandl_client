class Quandl::Client::Dataset
  module Validations

    extend ActiveSupport::Concern

    included do

      validates :code, presence: true, format: { with: Quandl::Pattern.code, message: "is invalid. Expected format: #{Quandl::Pattern.code.to_example}" }
      validates :display_url, allow_blank: true, url: true
      validate :data_should_be_valid!
      validate :dataset_data_should_be_valid!
      validate :data_row_count_should_match_column_count!
      validate :data_columns_should_not_exceed_column_names!
      validate :data_rows_should_have_equal_columns!
      validate :ambiguous_code_requires_source_code!

      validate :source_code_should_exist!

      before_save :enforce_required_formats
      after_save :save_dataset_data

    end

    def data_should_be_valid!
      if data? && !data.valid?
        data.errors.each{|k,v| self.errors.add( k,v ) }
        return false
      end
      true
    end

    def dataset_data_should_be_valid!
      if dataset_data? && !dataset_data.valid?
        dataset_data.errors.each{|k,v| self.errors.add( k,v ) }
        return false
      end
      true
    end

    def source_code_should_exist!
      if source_code.present?
        Quandl::Client::Source.cached[source_code] = Quandl::Client::Source.find(source_code) unless Quandl::Client::Source.cached.has_key?(source_code)
        source = Quandl::Client::Source.cached[source_code]
        self.errors.add( :source_code, "Could not find a source with the source_code '#{source_code}'" ) if source.blank? || source.code.blank?
        return false
      end
      true
    end

    def ambiguous_code_requires_source_code!
      if code.to_s.numeric? && source_code.blank?
        message = %Q{Pure numerical codes like "#{code}" are not allowed unless you include a source code. Do this:\nsource_code: <USERNAME>\ncode: #{code}}
        self.errors.add( :data, message )
        return false
      end
      true
    end

    def data_columns_should_not_exceed_column_names!
      if errors.size == 0 && data? && data.present? && column_names.present? && data.first.count != column_names.count
        self.errors.add( :data, "You may not change the number of columns in a dataset. This dataset has #{column_names.count} columns but you tried to send #{data.first.count} columns." )
        return false
      end
      true
    end

    def data_rows_should_have_equal_columns!
      # skip validation unless data is present
      return true unless data? && data.present?
      # use first row as expected column count
      column_count = data[0].count
      # check each row
      data.each_with_index do |row, index|
        # the row is valid if it's count matches the first row's count
        next if row.count == column_count
        # the row is invalid if the count is mismatched
        self.errors.add( :data, "Unexpected number of points in this row:\n#{row.join(',')}\nFound #{row.size-1} but expected #{data[0].size-1} based on precedent from the first row (#{data[0].join(',')})" )
        # return validation failure
        return false
      end
      true
    end

    def data_row_count_should_match_column_count!
      # skip validation unless data and column_names present
      return true unless data? && data.present? && column_names.present?
      # count the number of expected columns
      column_count = column_names.count
      # check each row
      data.each_with_index do |row, index|
        # the row is valid if it's count matches the first row's count
        next if row.count == column_count
        # the row is invalid if the count is mismatched
        self.errors.add( :data, "Unexpected number of points in this row:\n#{row.join(',')}\nFound #{row.size-1} but expected #{column_names.count-1} based on precedent from the header row (#{column_names.join(',')})" )
        # return validation failure
        return false
      end
      true
    end

    def save_dataset_data
      return if (!saved? && id.blank?)
      return if !data? || data.blank?
      dataset_data.id = id
      dataset_data.data = benchmark('data.to_csv'){ data.to_csv }
      benchmark('dataset_data.save'){ dataset_data.save }
      # update dataset's attributes with dataset_data's attributes
      attributes.each{|k,v| attributes[k] = dataset_data.attributes[k] if dataset_data.attributes.has_key?(k) }
      # update dataset errors with dataset_data
      @metadata[:status] = dataset_data.status unless dataset_data.saved?
      # inherit_errors(dataset_data) unless dataset_data.saved?
    end


    def inherit_errors(object)
      return unless object.respond_to?(:response_errors) && object.response_errors.respond_to?(:each)
      object.response_errors.each do |key, messages|
        if messages.respond_to?(:each)
          messages.each{|message| errors.add(key, message) }
        end
      end
      @metadata[:status] = object.status
      object
    end

    def enforce_required_formats
      self.source_code = self.source_code.to_s.upcase
      self.code = self.code.to_s.upcase
      self.locations_attributes = locations_attributes.to_json if locations_attributes.respond_to?(:to_json) && !locations_attributes.kind_of?(String)
    end

  end
end
