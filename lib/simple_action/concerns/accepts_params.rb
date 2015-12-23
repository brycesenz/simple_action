# coding: utf-8
require 'active_model'

module SimpleAction
  module AcceptsParams
    extend ActiveSupport::Concern

    attr_accessor :params_class

    def params(&block)
      klass_name = self.model_name.to_s
      klass_name = get_non_namespaced_module(klass_name)
      klass_name = klass_name + "Params"
      @params_class = Class.new(SimpleAction::Params).tap do |klass|
        extend ActiveModel::Naming
        klass.with_rails_helpers
        self.const_set(klass_name, klass)
        klass.class_eval(&block)
      end
    end

    def api_pie_documentation
      @params_class.api_pie_documentation
    end

    private
    def get_non_namespaced_module(name)
      name.split('::').last || name
    end
  end
end