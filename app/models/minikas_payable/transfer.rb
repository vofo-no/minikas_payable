module MinikasPayable
  class Transfer < MinikasPayable::ApplicationRecord
    belongs_to :payable, polymorphic: true
    belongs_to :batch, class_name: MinikasPayable::Batch.name, foreign_key: :minikas_payable_batch_id

    validate :nonzero_amount

    before_validation :attributes_from_payable

    def readonly?
      batch && batch.closed?
    end

    private

    def attributes_from_payable
      %i[bank_account recipient_name recipient_postal_code recipient_postal_city].each do |field|
        write_attribute(field, payable.send(payable.payable_options[field]))
      end
    end

    def nonzero_amount
      errors.add(:amount, :must_be_nonzero) unless amount.nonzero?
    end
  end
end