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
      params_accessor?(sym) &&
      params.respond_to?(sym)
    end

    def params_accessor?(sym)
      stripped = sym.to_s.gsub('=', '').to_sym
      params.attributes.include?(stripped)
    end
  end
end