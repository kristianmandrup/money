require 'money/exchange/base'

class Money
	module Exchange
		class SingleBank < Base
			def initialize bank
				super
			end
      # Exchanges the given +Money+ object to a new +Money+ object in
      # +to_currency+.
      #
      # @abstract Subclass and override +#exchange_with+ to implement a custom
      #  +Money::Bank+ class.
      #
      # @raise NotImplementedError
      #
      # @param [Money] from The +Money+ object to exchange from.
      # @param [Money::Currency, String, Symbol] to_currency The currency
      #  string or object to exchange to.
      # @yield [n] Optional block to use to round the result after making
      #  the exchange.
      # @yieldparam [Float] n The result after exchanging from one currency to
      #  the other.
      # @yieldreturn [Integer]
      #
      # @return [Money]
      def exchange_with(from, to_currency, &block)
        return bank.exchange_with(from, to_currency, &block)
      rescue Money::Bank::UnknownRate => e
        raise e
      rescue
        service_error!
      end		
   	end
	end
end