module MinikasPayable
  class ApplicationController < ActionController::Base
    include Pundit if Object.const_defined?(:Pundit)

    protect_from_forgery with: :exception
  end
end
