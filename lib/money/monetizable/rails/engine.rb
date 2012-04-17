require 'money/monetizable/rails/config'

module Monetizable
	module Rails
	  class Engine < ::Rails::Engine
			initializer "Rails configure monetizable" do
				[:active_record].each do |orm|
			  	Monetizable::Rails::OrmConfig.send(orm)
			  end
			end

			def self.orms
				[:mongoid, :mongo_mapper, :data_mapper, :sequel]
			end
		end
	end
end