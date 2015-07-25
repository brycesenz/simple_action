class FlexibleParamsSpecClass < SimpleAction::Service
    params do
      allow_undefined_params
      param :name
      param :age, type: :integer, default: 23
    end

    def execute
      (age * 3) + name.length
    end
  end