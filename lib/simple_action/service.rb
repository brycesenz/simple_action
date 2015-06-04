require_relative 'concerns/accepts_params'
require_relative 'concerns/transactable'
require_relative 'concerns/delegates_to_params'

module SimpleAction
  class Service    
    extend AcceptsParams
    extend Transactable
    include DelegatesToParams

    class << self
      def run(params = {})
        instance = self.new(params)
        result = transaction do
          instance.execute if instance.valid?
        end
        Response.new(instance, result)
      end

      def run!(params = {})
        response = run(params)
        if response.valid?
          response.result
        else
          raise ExecutionError, response.errors.to_s
        end
      end
    end

    def initialize(params={})
      @raw_params = params
      @params = self.class.params_class.new(params)
      @validity = nil
    end

    def params
      @params
    end

    def valid?
      # Adding this so that I don't assert validity each time.
      # TODO: I Still need a proper test for this.
      if @validity.nil?
        @validity = @params.valid?
      else
        @validity
      end
    end

    def errors
      @params.errors
    end

    def execute
      raise ImplementationError, "subclasses must implement 'execute' method."
    end
  end
end