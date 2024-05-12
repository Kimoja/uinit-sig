# frozen_string_literal: true

require 'spec_helper'
require 'pry'

class Signed
  include Uinit::Sig

  sig(attr_a: str, attr_b: int).returns(str | int).for(
    def basic_parameters(_attr_a, attr_b = 12)
      attr_b > 10 ? 'ok' : nil
    end
  )
end

RSpec.describe Uinit::Sig do
  describe '.sig' do
    let(:signed) { Signed.new }

    it 'FIXME' do
      expect(signed.basic_parameters('ok', 14)).to eq('ok')

      expect { signed.basic_parameters('ok', 'not a, int') }.to raise_error(
        Uinit::Sig::ParameterTypeError,
        /Type error on parameter 'attr_b'/
      )

      expect { signed.basic_parameters('ok', 9) }.to raise_error(
        Uinit::Sig::ReturnTypeError,
        /nil must be an instance of String/
      )
    end
  end
end
