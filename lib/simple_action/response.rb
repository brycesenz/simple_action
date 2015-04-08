module SimpleAction
  class Response
    def initialize(service_object, result = nil)
      @service_object = service_object
      @result = result
      valid?
    end

    def valid?
      @service_object.valid?
    end

    def errors
      @service_object.errors
    end

    def success?
      valid?
    end

    def result
      @result
    end
  end
end