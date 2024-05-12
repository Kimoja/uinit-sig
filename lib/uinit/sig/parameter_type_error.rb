# frozen_string_literal: true

module Uinit
  module Sig
    class ParameterTypeError < StandardError
      def initialize(parameter, type_error)
        super()

        @parameter = parameter
        @type_error = type_error

        set_backtrace(type_error.backtrace)
      end

      attr_reader :parameter, :type_error

      def message
        method = parameter.method
        file, line = method.method_origin.source_location

        "Type error on parameter '#{parameter.name}' " \
          "in method '#{method.method_name}' at '#{file}:#{line}', detail:\n#{type_error.message}"
      end
    end
  end
end
