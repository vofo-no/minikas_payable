module MinikasPayable
  class Engine < ::Rails::Engine
    isolate_namespace MinikasPayable

    initializer :extend_activerecord do
      if defined?(ActiveRecord)
        ActiveRecord::Base.include MinikasPayable::Payer
      end
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end
  end
end
