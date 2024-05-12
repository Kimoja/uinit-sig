# frozen_string_literal: true

# rubocop:disable Layout/EmptyLinesAroundAttributeAccessor
module Uinit
  module Sig
    class Method < Uinit::Struct
      include Memoizable

      struct do
        attr(:base, Class | Module)
        attr(:class_method, bool)

        attr(:parameters, [Parameter]).init(false)

        attr(:return_type, none | Uinit::Type::Base) do
          set { |type| Uinit::Type.from(type) unless type.nil? }
          init(false)
        end

        attr(:signed_name, Symbol) do
          default { (0...30).map { ('a'..'z').to_a[rand(26)] }.join.to_sym }
          init(false)
        end

        attr(:method_name, Symbol).init(false)
        attr(:checker, Proc).init(false)
      end

      def returns(return_type)
        self.return_type = return_type

        self
      end

      def for(method_name)
        self.method_name = method_name
        add_parameters_types
        MethodCompiler.compile(method: self)
      end

      def return_is!(value)
        return_type.is!(value)
      rescue Type::Error => e
        raise ReturnTypeError.new(self, e)
      end

      private

      memo def method_origin
        return base.instance_method(method_name) unless class_method

        base.singleton_class.instance_method(method_name)
      end

      def add_parameters_types
        method_origin.parameters.each_with_index do |(parameter_type, name), _i|
          parameter = parameters.find { _1.name == name }
          raise ArgumentError, "Unable to retrieve parameter '#{name}'" unless parameter

          parameter.parameter_type = parameter_type
        end
      end
    end
  end
end
# rubocop:enable Layout/EmptyLinesAroundAttributeAccessor
