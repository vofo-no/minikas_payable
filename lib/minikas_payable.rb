require "minikas_payable/engine"
require "minikas_payable/config"
require "minikas_payable/payer"

module MinikasPayable
  def self.config(&block)
    if block_given?
      block.call(MinikasPayable::Config)
    else
      MinikasPayable::Config
    end
  end
end
