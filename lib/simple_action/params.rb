require "simple_params"

module SimpleAction
  class Params < ::SimpleParams::Params
    # Use Rails Helpers by default
    # class << self
    #   def using_rails_helpers?
    #     true
    #   end
    # end
  end
end