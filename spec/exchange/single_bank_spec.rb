# spec to demonstrate simple wrapping of bank
require 'spec_helper'

class FailBank < Money::Bank::VariableExchange
	class BankFailed < StandardError
	end

	def initialize
	end

	def exchange_with(from, to_currency, &block)
		raise BankFailed, "Bank is out of order!"
	end
end

describe Money::Exchange::SingleBank do
	let(:bank) 				{ Money::Bank::VariableExchange.instance }
	let(:fail_bank) 	{ FailBank.new }

	before do
		Money.add_rate("USD", "EUR", 10)
    Money.default_bank = bank

    @money = Money.new(100_00, "USD")
    @exchange_result = @money.exchange_to("EUR")
  end

	describe 'Bank works' do
		let(:exchange) 	{ Money::Exchange::SingleBank.new bank }

		subject { exchange }

		describe '.exchange_with' do
			specify { subject.exchange_with(@money, "EUR").should == @exchange_result }
		end	
	end

	describe 'Bank fails' do	
		let(:exchange) 	{ Money::Exchange::SingleBank.new fail_bank }

		subject { exchange }

		describe '.exchange_with' do
			specify do
				lambda { subject.exchange_with(@money, "EUR") }.should raise_error(Money::Exchange::ServiceError)
			end
		end
	end
end