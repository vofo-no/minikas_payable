FactoryBot.define do
  factory :dummy_payer do
    amount { 100 }
    message { "Nice!" }
    bank_account { "00000000000" }
    recipient_name { "Veridian Dynamics" }
    recipient_postal_code { "0001" }
    recipient_postal_city { "Oslo" }
  end
end
