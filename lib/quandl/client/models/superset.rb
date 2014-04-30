class Quandl::Client::Superset < Quandl::Client::Base
  
  scope :query, :page, :owner, :code, :source_code
  
  attributes :id, :source_code, :code, :name, :urlize_name, :description, :updated_at, :private
  attributes :column_codes, :column_names
  attributes :frequency, :from_date, :to_date
  
  validates :code, presence: true, format: { with: Quandl::Pattern.code, message: "is invalid. Expected format: #{Quandl::Pattern.code.to_example}" }
  validates :column_codes, presence: true
  validate :column_codes_should_be_valid!
  
  def self.find_or_build( attributes={} )
    attrs = attributes.symbolize_keys!
    # by id
    record = self.find(attrs[:id]) if attrs[:id].present?
    # by source_code/code
    record = self.find(File.join(attrs[:source_code], attrs[:code])) if !record.try(:exists?) && attrs[:source_code].present? && attrs[:code].present?
    # by code
    record = self.find(attrs[:code]) if !record.try(:exists?) && attrs[:code].present?
    # build
    record = self.new unless record.try(:exists?)
    record.assign_attributes(attrs)
    record
  end
  
  def self.example
    self.new( code: "SUPERSET_EXAMPLE", name: "Superset Name", description: "Superset description", column_codes: ['NSE.OIL.1'], column_names: ['Column Name'] )
  end
  
  def data
    @data ||= Quandl::Client::Dataset::Data.with_id(id)
  end
  
  def full_url
    File.join(Quandl::Client::Base.url.gsub(/api\/?/, ''), full_code)
  end
  
  def full_code
    File.join(self.source_code.to_s, self.code.to_s)
  end
  
  protected
  
  def column_codes_should_be_valid!
    # must be an array
    unless column_codes.respond_to?(:each)
      # failure
      self.errors.add( :column_codes, "expected an array, but got #{column_codes.class}.")
      # nothing more to do
      return false
    end
    # check each code
    column_codes.each do |code|
      # is the code valid?
      next if code =~ /#{Quandl::Pattern.code}\.#{Quandl::Pattern.code}\.[0-9]+/
      # otherwise report error
      self.errors.add( :column_codes, "Code '#{code}' is invalid. Expected: /#{Quandl::Pattern.code.to_example}.#{Quandl::Pattern.code.to_example}.INTEGER/" )
      # nothing more to do here
      return false
    end
    # success
    true
  end
  
end