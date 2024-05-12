# frozen_string_literal: true

module Uinit
  module Sig
    class MethodCompiler < Uinit::Struct
      def self.compile(...)
        new(...).compile
      end

      struct do
        attr(:method, Method)
      end

      def compile
        compile_arguments_check_method
        compile_wrapped_method
      end

      def compile_arguments_check_method
        compile_method(<<~RUBY, __FILE__, __LINE__ + 1)
          def __check_#{method.method_name}(#{compile_parameters_sig})
            __method__ = _signed_methods.#{method.signed_name}
            #{compile_parameters_check}
          end
        RUBY
      end

      def compile_wrapped_method
        compile_method(<<~RUBY, __FILE__, __LINE__ + 1)
          def #{method.method_name}(...)
            method = _signed_methods.#{method.signed_name}
            __check_#{method.method_name}(...)
            #{compile_original_method_call}
          end
        RUBY
      end

      private

      def compile_method(str, file, line)
        puts str.gsub(/^$\s*\n/, '').gsub(/\s+$/, '')
        puts '----------------------------------------------------------------'

        method.base.class_eval(str.gsub(/^$\s*\n/, '').gsub(/\s+$/, ''), file, line)
      end

      def compile_parameters_sig
        method.parameters.map { compile_parameter_sig(_1).to_s.strip }.join(', ')
      end

      def compile_parameter_sig(parameter)
        return parameter.name if parameter.req_arg?
        return "#{parameter.name} = Uinit::Sig::UNDEFINED" if parameter.opt_arg?
        return "*#{parameter.name}" if parameter.rest_arg?

        return "#{parameter.name}:" if parameter.req_kwarg?
        return "#{parameter.name}: Uinit::Sig::UNDEFINED" if parameter.opt_kwarg?

        "**#{parameter.name}" if parameter.rest_kwarg?
      end

      def compile_parameters_check
        parameters_check = method.parameters.map.with_index do |parameter, index|
          compile_parameter_check(parameter, index).to_s.strip
        end

        parameters_check.join("\n")
      end

      def compile_parameter_check(parameter, index)
        return unless parameter.typed?

        if parameter.opt?
          return <<~RUBY
            unless #{parameter.name} == Uinit::Sig::UNDEFINED
              __method__.parameters[#{index}].is!(#{parameter.name})
            end
          RUBY
        end

        <<~RUBY
          __method__.parameters[#{index}].is!(#{parameter.name})
        RUBY
      end

      def compile_original_method_call
        unless method.return_type
          return <<~RUBY
            method.method_origin.bind_call(self, ...)
          RUBY
        end

        <<~RUBY
          ret = method.method_origin.bind_call(self, ...)
          method.return_is!(ret)
          ret
        RUBY
      end
    end
  end
end

# class A
#   def jo(...)
#     e = proc do |a, b = "ok"|
#       pp a, b
#     end
#     e.call(...)
#   end
# end

# def si(...)
#   a = A.new
#   A.instance_method(:jo).bind_call(a, ...)
# end
