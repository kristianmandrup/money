# spec to demonstrate fallback to alternative if one or more bank services fail
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

describe Money::Exchange::MultipleBanks do
	let(:bank) 			{ Money::Bank::VariableExchange.instance }

	before do
		Money.add_rate("USD", "EUR", 10)
		@usd = Money::Currency.new("USD")
    @money = Money.new(100_00, "USD")
    Money.default_bank = bank
    @exchange_result = @money.exchange_to("EUR")
  end

	describe 'Simple setup' do
		let(:exchange) 	{ Money::Exchange::MultipleBanks.new bank, bank }

		subject { exchange }

		describe '.exchange_with' do
			specify { subject.exchange_with(@money, "EUR").should == @exchange_result }
		end	
	end

	describe 'Fallback to alternative' do
		let(:fail_bank) 	{ FailBank.new }
		let(:exchange) 		{ Money::Exchange::MultipleBanks.new fail_bank, bank }

		subject { exchange }

		describe '.exchange_with' do
			specify { subject.exchange_with(@money, "EUR").should == @exchange_result }
		end	
	end

	describe 'All banks fail' do
		let(:fail_bank) 			{ FailBank.new }
		let(:other_fail_bank) { FailBank.new }		
		let(:exchange) 				{ Money::Exchange::MultipleBanks.new fail_bank, other_fail_bank }

		before do
	    @money = Money.new(100_00, "USD")
	  end

		subject { exchange }

		describe '.exchange_with' do
			it 'should raise ExchangeError' do
				lambda { subject.exchange_with(@money, "EUR") }.should raise_error(Money::Exchange::ServiceError)
			end
		end	
	end	
end