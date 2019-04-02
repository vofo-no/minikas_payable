FactoryBot.define do
  factory :transfer, class: MinikasPayable::Transfer do
    association :batch, factory: :batch
    association :payable, factory: :dummy_payer, strategy: :build_stubbed
    amount { 1 }
    bank_account { "00000000000" }
    message { "Hello, I love you!" }
  end
end
