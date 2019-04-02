require 'rails_helper'

RSpec.describe MinikasPayable::Transfer, type: :model do
  subject { MinikasPayable::Transfer.new }

  def mock_batch(closed = false)
    batch = build_stubbed(:batch)
    allow(batch).to receive(:closed?).and_return closed
    allow(subject).to receive(:batch).and_return batch
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

  context "with exitsting transfer in open batch" do
    before do
      @payer = create :dummy_payer
      @payer.transfer
    end

    it "does nothing if amount is balanced" do
      expect { @payer.transfer }.not_to change(MinikasPayable::Transfer, :count)
      expect { @payer.transfer }.not_to change(MinikasPayable::Batch, :count)
    end

    it "adjust the existing amount" do
      @payer.amount += 100
      transfer_id = MinikasPayable::Transfer.last.id

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.find(transfer_id).amount }.by(100)
    end

    it "adjust the existing amount" do
      @payer.amount -= 50
      transfer_id = MinikasPayable::Transfer.last.id

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.find(transfer_id).amount }.by(-50)
    end

    it "adjust the existing amount" do
      @payer.amount -= 500
      transfer_id = MinikasPayable::Transfer.last.id

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.find(transfer_id).amount }.by(-500)
    end

    it "deletes the transfer if it's zero" do
      @payer.amount = 0
      transfer_id = MinikasPayable::Transfer.last.id

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.count }.by(-1)
    end
  end

  context "with exitsting transfer in closed batch" do
    before do
      @payer = create :dummy_payer
      @payer.transfer
      MinikasPayable::Batch.last.update(closed: true)
    end

    it "does nothing if amount is balanced" do
      expect { @payer.transfer }.not_to change(MinikasPayable::Transfer, :count)
      expect { @payer.transfer }.not_to change(MinikasPayable::Batch, :count)
    end

    it "keeps the existing amount" do
      @payer.amount += 100
      transfer_id = MinikasPayable::Transfer.last.id

      expect { @payer.transfer }.not_to change { MinikasPayable::Transfer.find(transfer_id).amount }
    end

    it "creates a new transfer for correcting the amount" do
      @payer.amount += 550

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.count }.by(1)
      expect(@payer.transfers.last.amount).to eq(550)
    end

    it "creates a new transfer for correcting the amount" do
      @payer.amount -= 50

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.count }.by(1)
      expect(@payer.transfers.last.amount).to eq(-50)
    end

    it "creates a new transfer for correcting the amount" do
      @payer.amount = 0
      transfer_id = MinikasPayable::Transfer.last.id

      expect { @payer.transfer }.to change { MinikasPayable::Transfer.count }.by(1)
      expect(@payer.transfers.last.amount).to eq(-100)
    end
  end

  it "infers attributes from payer" do
    payer = create :dummy_payer
    payer.transfer

    transfer = MinikasPayable::Transfer.last
    expect(transfer).to have_attributes(payer.slice(:recipient_name, :recipient_postal_code, :recipient_postal_city))
  end

  it "infers message from payer" do
    payer = create :dummy_payer
    payer.transfer

    transfer = MinikasPayable::Transfer.last
    expect(transfer.message).to start_with("Nice!")
  end

  describe :validation do
    subject { build_stubbed :transfer }

    it "is invalid with zero amount" do
      subject.amount = 0
      expect(subject).to be_invalid
    end

    it "is valid with negative amount" do
      subject.amount = -1
      expect(subject).to be_valid
    end

    it "is invalid with positive amount" do
      subject.amount = 1
      expect(subject).to be_valid
    end
  end

end
