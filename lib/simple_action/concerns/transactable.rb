# coding: utf-8

begin
  require 'active_record'
rescue LoadError
  module ActiveRecord
    Rollback = Class.new(SimpleAction::Error)

    class Base
      def self.transaction(*)
        yield
      rescue Rollback
      end
    end
  end
end

module SimpleAction
  module Transactable
    extend ActiveSupport::Concern

    # @yield []
    def transaction
      return unless block_given?

      if transaction?
        ActiveRecord::Base.transaction(transaction_options) do
          yield
        end
      else
        yield
      end
    end

    # @return [Boolean]
    def transaction?
      true
    end

    # @return [Hash]
    def transaction_options
      {}
    end
  end
end