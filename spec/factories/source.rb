FactoryGirl.define do

  factory :source do
    sequence(:code) { |n| "QUANDL_CLIENT_#{(Time.now.to_f * 1000).to_i}_#{n}" }
    name "Quandl Client Source"
    description "Quandl Client Source Spec"
    sequence(:host) { |n| "http://quandl.com/host/#{(Time.now.to_f * 1000).to_i}_#{n}" }
  end

end