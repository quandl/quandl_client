FactoryGirl.define do

  factory :sheet do
    sequence(:title) { |n| "Test sheet #{n} #{(Time.now.to_f * 1000).to_i}" }
    description{ "Test sheet description."}
  end

end