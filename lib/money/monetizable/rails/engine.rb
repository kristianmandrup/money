require 'money/monetizable/rails/config'

module Monetizable
	module Rails
	  class Engine < ::Rails::Engine
			initializer "Rails configure monetizable" do
				[:active_record, :mongoid, :mongo_mapper, :data_mapper, :sequel].each do |orm|
			  	Monetizable::Rails::OrmConfig.send(orm)
			  end		  
			end
		end
	end
end