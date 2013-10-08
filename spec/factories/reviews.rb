FactoryGirl.define do
  factory :review do
    reviewable factory: :product
    reviewer factory: :user
  end
end