require "active_model"
require_relative 'concerns/accepts_params'
require_relative 'concerns/transactable'
require_relative 'concerns/delegates_to_params'

module SimpleAction
  class Service    
    extend AcceptsParams
    extend Transactable
    include DelegatesToParams

    class << self
      def model_name 
        ActiveModel::Name.new(self)
      end

      def run(params = {})
        instance = self.new(params)
        result = transaction do
          if instance.valid?
            outcome = instance.execute
            instance.errors.empty? ? outcome : nil
          end
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
      @initial_params_valid = nil
    end

    def params
      @params
    end

    def valid?
      initial_params_valid? && errors.empty?
    end

    def errors
      @params.errors
    end

    def execute
      raise ImplementationError, "subclasses must implement 'execute' method."
    end

    private
    def initial_params_valid?
      if @initial_params_valid.nil?
        @initial_params_valid = @params.valid?
      else
        @initial_params_valid
      end
    end
  end
end