class UnflexibleParamsSpecClass < SimpleAction::Service
  params do
    param :name
    param :age, type: :integer, default: 23
  end

  def execute
    (age * 3) + name.length
  end
end