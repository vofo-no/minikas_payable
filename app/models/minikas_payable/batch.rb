module MinikasPayable
  class Batch < MinikasPayable::ApplicationRecord
    TRANSFERS_CLASS = MinikasPayable::Transfer
    scope :with_transfers, -> { select(["#{self.table_name}.*", "SUM(#{TRANSFERS_CLASS.table_name}.amount) as amount", "COUNT(#{TRANSFERS_CLASS.table_name}.id) as lines"]).joins(:transfers).group("#{self.table_name}.id") }

    has_many :transfers, class_name: TRANSFERS_CLASS.name
    belongs_to :owner, polymorphic: true

    validates :number, uniqueness: { scope: [:owner_type, :owner_id] }, allow_nil: true

    before_create :make_number

    def to_s
      "#{model_name.human} #{number} (#{I18n.l(updated_at.to_date)})"
    end

    private

      def make_number
        batches = self.class.where(owner: owner)
        self.number = batches.order(number: :desc).limit(1).pluck(:number).first.to_i
        begin
          self.number = self.number.next
        end while batches.exists?(number: self.number)
      end
  end
end