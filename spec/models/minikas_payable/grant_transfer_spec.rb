require 'rails_helper'

RSpec.describe MinikasPayable::Transfer, type: :model do
  subject { MinikasPayable::Transfer.new }

  def mock_batch(closed = false)
    batch = double(MinikasPayable::Batch)
    allow(batch).to receive(:closed).and_return closed
    allow(subject).to receive(:batch).and_return batch
  end

  context "when course has transfers" do
    before do
      course = create :awarded_course
      course.granted += 200
      course.transfer
    end

    it "infers type" do
      expect(GrantTransfer.last).to be_a GrantTransferExtra
    end
  end

  context "when course has no transfers" do
    before do
      course = create :awarded_course
      course.grant_transfers.destroy_all
      course.transfer
    end

    it "infers type" do
      expect(GrantTransfer.last).to be_a GrantTransfer
    end
  end

  context "when amount is negative" do
    before do
      course = create :awarded_course
      course.refund(-200)
    end

    it "infers type" do
      expect(GrantTransfer.last).to be_a GrantTransferRefund
    end
  end

  it "is not readonly if new_record" do
    expect(subject).not_to be_readonly
  end

  it "is not readonly if saved and batch is open" do
    mock_batch()
    allow(subject).to receive(:new_record?).and_return false

    expect(subject).not_to be_readonly
  end

  it "is readonly if saved and batch is not open" do
    mock_batch(true)
    allow(subject).to receive(:new_record?).and_return false

    expect(subject).to be_readonly
  end

  describe :validation do
    subject { build :grant_transfer }

    it "is invalid with zero amount" do
      subject.amount = 0
      expect(subject).to be_invalid
    end

    it "is invalid with negative amount" do
      subject.amount = -1
      expect(subject).to be_invalid
    end

    it "is invalid with positive amount" do
      subject.amount = 1
      expect(subject).to be_valid
    end
  end

end
