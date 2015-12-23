require "simple_params"

module SimpleAction
  class Params < ::SimpleParams::Params
    with_rails_helpers
  end
end