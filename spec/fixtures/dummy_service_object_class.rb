require 'active_model'

class DummyServiceObjectClass
  include ActiveModel::Validations

  attr_accessor :name

  def initialize(params = {})
    params.each { |k, v| send("#{k}=", v) }
  end

  validates :name, presence: true
end
