module SimpleAction
  class Error < StandardError
  end

  class ImplementationError < Error
  end

  class ExecutionError < Error
  end
end