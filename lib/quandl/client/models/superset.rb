class Quandl::Client::Superset < Quandl::Client::Base
  
  scope :query, :page, :owner, :code, :source_code
  
  attributes :id, :source_code, :code, :name, :urlize_name, :description, :updated_at, :private
  attributes :column_codes, :column_names
  attributes :frequency, :from_date, :to_date
  
  validates :code, presence: true, format: { with: Quandl::Pattern.code, message: "is invalid. Expected format: #{Quandl::Pattern.code.to_example}" }
  validates :column_codes, presence: true
  validate :column_codes_should_be_valid!
  
  def self.example
    self.new( code: "EXAMPLE", name: "Superset Name", description: "Superset description", column_codes: ['SOURCE.DATASET.1'], column_names: ['Column Name'] )
  end
  
  def data
    @data ||= Quandl::Client::Dataset::Data.with_id(id)
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