# frozen_string_literal: true

module MinikasPayable
  class BatchesController < MinikasPayable::ApplicationController
    def index
      @batches = find_batches.with_transfers
    end

    def show
      find_batch
    end

    def update
      batch = find_batch
      batch.update(closed: !batch.closed?)
      redirect_to batch
    end

    def destroy
      batch = find_batch
      batch.destroy unless batch.closed?
      redirect_to MinikasPayable::Batch
    end

    private

      def find_batches
        if respond_to? :policy_scope
          policy_scope(MinikasPayable::Batch)
        else
          logger.warn "Did not find a policy_scope method. No batches will be returned."
          MinikasPayable::Batch.none
        end
      end

      def find_batch
        @batch ||= find_batches.find params[:id]
      end
  end
end