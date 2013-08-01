FactoryGirl.define do

  factory :dataset do
    source_code "QUANDL_CLIENT_TEST_SOURCE"
    sequence(:code) { |n| "QUANDL_CLIENT_#{n}" }
    name "Quandl Client Dataset"
    description "Quandl Client Dataset Spec"
    column_spec "[0,[\"Date \\n\",{}],[\"Column 1 \",{}],[\"Column 2 \",{}]]"
  end

end