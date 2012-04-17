# demonstrate configure Money with currency exchange
# encoding: utf-8

require "spec_helper"

class FailBank < Money::Bank::VariableExchange
	class BankFailed < StandardError
	end

	def initialize
	end

	def exchange_with(from, to_currency, &block)
		raise BankFailed, "Bank is out of order!"
	end
end

describe Money do
  describe ".exchange_to" do
  	let(:bank) 						{ Money::Bank::VariableExchange.instance }
  	let(:exchange) 				{ Money::Exchange::SingleBank.new bank }
  	let(:fail_bank) 			{ FailBank.new }
  	let(:alt_exchange) 		{ Money::Exchange::MultiBank.new fail_bank, bank }
		let(:fail_exchange) 	{ Money::Exchange::SingleBank.new fail_bank }

		before do
			Money.add_rate("USD", "EUR", 10)
		end

  	describe 'Exchange works' do
			subject { Money.new 100, "USD", bank, exchange }

			specify { subject.exchange_to("EUR").should > 0 }
  	end

  	describe 'Exchange works with alternative bank' do
			subject { Money.new 100, "USD", bank, alt_exchange }

			specify { subject.exchange_to("EUR").should > 0 }
  	end

  	describe 'Exchange fails with failing bank' do
			subject { Money.new 100, "USD", bank, fail_exchange }

			specify do
				lambda { subject.exchange_to("EUR") }.should raise_error(Money::Exchange::ServiceError)
			end
  	end
  end
end
