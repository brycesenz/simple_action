class ParamsSpecClass < SimpleAction::Params
  param :reference, type: :object, optional: true
  param :name
  param :age, type: :integer, optional: true
  param :color, default: "red", validations: { inclusion: { in: ["red", "green"] }}

  nested_hash :address do
    param :street
    param :city, validations: { length: { in: 4..40 } }
    param :zip_code, optional: true
    param :state, default: "North Carolina"
  end
end
