FactoryBot.define do
  factory :batch, class: MinikasPayable::Batch do
    number { 1 }
    closed { false }
    date { "2019-03-12" }
    association :owner, factory: :dummy_payer
  end
end
