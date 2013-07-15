FactoryGirl.define do

  factory :dataset do
    source_code "QUANDL_CLIENT_TEST_SOURCE"
    sequence(:code) { |n| "QUANDL_CLIENT_#{n}" }
    name "Quandl Client Dataset"
    description "Quandl Client Dataset Spec"
  end

end