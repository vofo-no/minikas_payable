require_dependency 'pundit'
require 'minikas_payable/config'

module MinikasPayable
  class ApplicationController < Config.parent_controller.constantize
    include Pundit

    protect_from_forgery with: :exception
  end
end
