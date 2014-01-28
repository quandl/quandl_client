FactoryGirl.define do

  factory :dataset do
    source_code "QUANDL_CLIENT_TEST_SOURCE"
    sequence(:code) { |n| "QUANDL_CLIENT_#{(Time.now.to_f * 1000).to_i}_#{n}" }
    name "Quandl Client Dataset"
    description "Quandl Client Dataset Spec"
    # column_names ['Date', "Column 1", "Column 2"]
  end

end