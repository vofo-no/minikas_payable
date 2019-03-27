module MinikasPayable
  class Transfer < MinikasPayable::ApplicationRecord
    belongs_to :payable, polymorphic: true
    belongs_to :batch, class_name: MinikasPayable::Batch.name

    before_validation :attributes_from_payable

    private

    def attributes_from_payable
      %i[bank_account recipient_name recipient_postal_code recipient_postal_city].each do |field|
        write_attribute(field, payable.send(payable.payable_options[field]))
      end
    end
  end
end