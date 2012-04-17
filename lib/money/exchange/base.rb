module Money
	module Exchange
		class Base
	    class ExchangeError < StandardError
	    end

			attr_reader :bank

			def initialize bank				
				@bank = bank if valid_bank? bank
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
        raise NotImplementedError, "#exchange_with must be implemented"
      end			

      protected

      def valid_bank? bank
      	raise ArgumentError, "Not a valid bank: #{bank}" unless bank.kind_of?(Money::Bank::Base)
      	true
      end
		end
	end
end