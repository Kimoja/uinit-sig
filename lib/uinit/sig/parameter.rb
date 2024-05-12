# frozen_string_literal: true

module Uinit
  module Sig
    class Parameter < Uinit::Struct
      struct do
        attr(:name, Symbol)

        attr(:type, none | Uinit::Type::Base).set { |type| Uinit::Type.from(type) unless type.nil? }
        attr(:method, Method)

        attr(:parameter_type, any_of(:req, :opt, :rest, :keyreq, :key, :keyrest)).init(false)
      end

      def req_arg?
        parameter_type == :req
      end

      def opt_arg?
        parameter_type == :opt
      end

      def rest_arg?
        parameter_type == :rest
      end

      def req_kwarg?
        parameter_type == :keyreq
      end

      def opt_kwarg?
        parameter_type == :key
      end

      def rest_kwarg?
        parameter_type == :keyrest
      end

      def opt?
        opt_arg? || opt_kwarg?
      end

      def typed?
        !type.nil?
      end

      def is!(value)
        type.is!(value)
      rescue Type::Error => e
        raise ParameterTypeError.new(self, e)
      end
    end
  end
end
