# frozen_string_literal: true

module MinikasPayable
  class TransfersController < MinikasPayable::ApplicationController
    def destroy
      transfer.destroy
      redirect_to main_app.url_for(transfer.payable)
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: main_app.root_path)
    end

    private

      def find_transfers
        policy_scope(MinikasPayable::Transfer).joins(:batch).merge(policy_scope(MinikasPayable::Batch).where(closed: false))
      end

      def transfer
        @transfer ||= find_transfers.find params[:id]
      end
  end
end