# coding: utf-8
require 'active_model'

module SimpleAction
  module DelegatesToParams
    extend ActiveSupport::Concern

    def respond_to?(sym, include_private = false)
      pass_sym_to_params?(sym) || super(sym, include_private)
    end

    def method_missing(sym, *args, &block)
      return params.send(sym, *args, &block) if pass_sym_to_params?(sym)
      super(sym, *args, &block)
    end

    private
    def pass_sym_to_params?(sym)
      params.present? &&
      delegatable_params_method?(sym) &&
      params.respond_to?(sym)
    end

    def delegatable_params_method?(sym)
      params_accessor?(sym) ||
      attributes_method?(sym) ||
      build_method?(sym)
    end

    def params_accessor?(sym)
      stripped = sym.to_s.gsub('=', '').to_sym
      params.attributes.include?(stripped)
    end

    def attributes_method?(sym)
      sym.to_s.gsub('=', '').end_with?('_attributes')
    end

    def build_method?(sym)
      sym.to_s.gsub('=', '').start_with?('build_')
    end

    module ClassMethods
      def reflect_on_association(sym)
        params_class.reflect_on_association(sym)
      end
    end
  end
end