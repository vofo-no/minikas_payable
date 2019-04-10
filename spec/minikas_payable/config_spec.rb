require 'spec_helper'

describe MinikasPayable::Config do
  describe "parent_controller" do
    it "uses default class" do
      expect(MinikasPayable.config.parent_controller).to eq '::ActionController::Base'
    end

    it "uses other class" do
      MinikasPayable.config do |config|
        config.parent_controller = 'FooBar'
      end

      expect(MinikasPayable.config.parent_controller).to eq 'FooBar'
    end
  end
end