module MinikasPayable
  # Call the <tt>payable</tt> class method to enable the record to make transfers.
  #
  #    class Course < ActiveRecord::Base
  #      payable
  #    end
  #
  # This will enable any instance of course to call <tt>transfer</tt>.
  #
  #    course.transfer
  #
  # See <tt>MinikasPayable::Payer::ClassMethods#payable</tt> for configuration options.
  module Payer
    extend ActiveSupport::Concern

    module ClassMethods
      # == Configuration options
      #
      # * +amount+ The default payable amount. Defaults to ```:amount```.
      # * +note+ Message for this transfer record. Defaults to ```:to_s```.
      # * +bank_account+ Recipient's bank account number. Defaults to ```:bank_account```.
      # * +recipient_name+ Recipient's name. Defaults to ```:recipient_name```.
      # * +recipient_postal_code+ Recipient's postal code. Defaults to ```:recipient_postal_code```.
      # * +recipient_postal_city+ Recipient's postal city. Defaults to ```:recipient_postal_city```.
      # * +owner+ ActiveRecord instance that owns the transaction. Defaults to ```:learning_association```.
      def payable(amount:                :amount,
                  note:                  :to_s,
                  bank_account:          :bank_account,
                  recipient_name:        :recipient_name,
                  recipient_postal_code: :recipient_postal_code,
                  recipient_postal_city: :recipient_postal_city,
                  owner:                 :learning_association)
        return if included_modules.include?(MinikasPayable::Payer::PayableInstanceMethods)

        include MinikasPayable::Payer::PayableInstanceMethods

        class_attribute :payable_options, instance_writer: false

        self.payable_options = {
          amount: amount,
          note: note,
          bank_account: bank_account,
          recipient_name: recipient_name,
          recipient_postal_code: recipient_postal_code,
          recipient_postal_city: recipient_postal_city,
          owner: owner
        }

        has_many :transfers, as: :payable, class_name: MinikasPayable::Transfer.name, inverse_of: :payable
      end
    end

    module PayableInstanceMethods
      def paid
        @paid ||= transfers.sum(:amount)
      end

      def unpaid
        send(payable_options[:amount]).to_i - paid
      end

      def transfer_amount(amount)
        write_transfer(amount: amount) if amount.nonzero?
      end

      def transfer
        transfer_amount(unpaid)
      end

      private

      def reset_paid
        @paid = nil
      end

      def transfer_message
        send(payable_options[:note]).truncate(29).ljust(30).to_s
      end

      def transfer_batch
        MinikasPayable::Batch.where(owner: send(payable_options[:owner]), closed: false).first_or_create!
      end

      def write_transfer(amount: 0)
        raise ArgumentError, 'Transfer cannot be zero.' if amount.zero?

        transfer_batch.tap do |batch|
          new_transfer = transfers.where(batch: batch).first_or_initialize
          new_transfer.amount += amount

          if new_transfer.amount.zero?
            new_transfer.destroy
          else
            new_transfer.message = transfer_message
            new_transfer.save!
          end
        end

        reset_paid
      end
    end
  end
end
