# frozen_string_literal: true

require 'zeitwerk'

require 'uinit/type'
require 'uinit/structure'

module Uinit; end

Zeitwerk::Loader.for_gem.tap do |loader|
  loader.push_dir(__dir__, namespace: Uinit)
  loader.setup
end

module Uinit
  module Sig
    include Memoizable

    UNDEFINED = Class.new.new

    def self.included(base)
      base.extend(ClassMethods)
    end

    class SignedMethods; end

    module ClassMethods
      include Memoizable
      include Type::Context

      memo def signed_methods
        if respond_to?(:superclass) && superclass.respond_to?(:signed_methods)
          return Class.new(superclass.signed_methods.class).new
        end

        Class.new(SignedMethods).new
      end

      def sig(**params)
        build_method(false, **params)
      end

      def sig_self(**params)
        build_method(true, **params)
      end

      private

      def build_method(class_method, **params)
        method = Method.new(base: self, class_method:)

        parameters = params.map { |name, type| Parameter.new(name:, type:, method:) }
        method.parameters = parameters

        signed_methods.class.define_method(method.signed_name) { method }

        method
      end
    end

    private

    memo def _signed_methods = self.class.signed_methods
  end
end
