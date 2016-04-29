FactoryGirl.define do
  factory :board do
    name "General Board"
    slug "general"
    factory :faq do
      name "faq"
      slug "faq"
    end

  end

end