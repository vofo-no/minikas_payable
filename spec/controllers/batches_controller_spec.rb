# frozen_string_literal: true

require "rails_helper"

RSpec.describe MinikasPayable::BatchesController, type: :controller do
  routes { MinikasPayable::Engine.routes }
  let(:batch) { create :batch }

  before :each do
    module MockScope
      def policy_scope(scoped)
        scoped.all
      end
    end

    controller.class.include MockScope
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: batch.to_param }
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    it "toggles batch closed" do
      expect {
        put :update, params: { id: batch.to_param }
      }.to change{ MinikasPayable::Batch.find(batch.to_param).closed? }.from(false).to(true)
    end

    it "redirects to the batch" do
      put :update, params: { id: batch.to_param }
      expect(response).to redirect_to(batch)
    end

    context "with closed batch" do
      before do
        batch.update!(closed: true)
      end

      it "toggles batch closed" do
        expect {
          put :update, params: { id: batch.to_param }
        }.to change{ MinikasPayable::Batch.find(batch.to_param).closed? }.from(true).to(false)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      create(:transfer, batch: batch)
    end

    context "nonempty batch" do
      it "does not destroy the requested batch" do
        expect {
          delete :destroy, params: { id: batch.to_param }
        }.not_to change(MinikasPayable::Batch, :count)
      end

      it "redirects to the batches list" do
        delete :destroy, params: { id: batch.to_param }
        expect(response).to redirect_to(batches_url)
      end
    end

    context "empty batch" do
      before do
        MinikasPayable::Transfer.last.destroy!
      end

      it "destroys the requested batch" do
        expect {
          delete :destroy, params: { id: batch.to_param }
        }.to change(MinikasPayable::Batch, :count).by(-1)
      end

      it "redirects to the batches list" do
        delete :destroy, params: { id: batch.to_param }
        expect(response).to redirect_to(batches_url)
      end
    end

    context "with closed batch" do
      before do
        batch.update!(closed: true)
      end

      it "does not destroy the requested batch" do
        expect {
          delete :destroy, params: { id: batch.to_param }
        }.not_to change(MinikasPayable::Batch, :count)
      end

      it "redirects to the batches list" do
        delete :destroy, params: { id: batch.to_param }
        expect(response).to redirect_to(batches_url)
      end
    end
  end
end
