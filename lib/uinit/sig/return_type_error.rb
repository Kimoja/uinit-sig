# frozen_string_literal: true

module Uinit
  module Sig
    class ReturnTypeError < StandardError
      def initialize(method, type_error)
        super()

        @method = method
        @type_error = type_error

        set_backtrace(type_error.backtrace)
      end

      attr_reader :method, :type_error

      def message
        file, line = method.method_origin.source_location

        "Return type error in method '#{method.method_name}' " \
          "at '#{file}:#{line}', detail:\n#{type_error.message}"
      end
    end
  end
end
