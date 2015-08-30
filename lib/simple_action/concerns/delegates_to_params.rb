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


      # # Overriding this method to allow for non-strict enforcement!
      # def method_missing(method_name, *arguments, &block)
      #   if strict_enforcement?
      #     raise SimpleParamsError, "parameter #{method_name} is not defined."
      #   else
      #     if @original_params.include?(method_name.to_sym)
      #       value = @original_params[method_name.to_sym]
      #       if value.is_a?(Hash)
      #         define_anonymous_class(method_name, value)
      #       else
      #         Attribute.new(self, method_name).value = value
      #       end
      #     end
      #   end
      # end

      # def respond_to?(method_name, include_private = false)
      #   if strict_enforcement?
      #     super
      #   else
      #     @original_params.include?(method_name.to_sym) || super
      #   end
      # end


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