FactoryGirl.define do
  factory :topic do
    name { "topic#{Time.now.to_f}#{rand(1000)}" }

  end

end