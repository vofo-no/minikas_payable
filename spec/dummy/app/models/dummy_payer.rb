class DummyPayer < ApplicationRecord
  payable note: :message

  belongs_to :learning_association, class_name: "DummyPayer", optional: true, default: -> { id ? nil : DummyPayer.find_or_create_by(id: 9999) }
end
