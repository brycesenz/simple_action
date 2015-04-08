# coding: utf-8
require 'active_model'

module SimpleAction
  module AcceptsParams
    extend ActiveSupport::Concern

    attr_accessor :params_class

    def params(&block)
      @params_class = Class.new(Params).tap do |klass|
        name_function = Proc.new {
          def self.model_name
            ActiveModel::Name.new(self, self, "Params")
          end
        }
        klass.class_eval(&name_function)
        klass.class_eval(&block)
      end
    end

    def api_pie_documentation
      @params_class.api_pie_documentation
    end
  end
end