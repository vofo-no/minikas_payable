module MinikasPayable
  module Config
    class << self
      attr_accessor :parent_controller

      def reset
        @parent_controller = '::ActionController::Base'
      end
    end

    reset
  end
end