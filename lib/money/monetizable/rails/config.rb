module Monetizable
	module Rails
		module OrmConfig
			def self.active_record
				ActiveRecord::Base.send(:include, Monetizable) if defined?(ActiveRecord::Base)
			end

			def self.mongoid
				Mongoid::Document.send(:include, Monetizable) if defined?(Mongoid::Document)
			end

			def self.mongo_mapper
				MongoMapper::Document.send(:include, Monetizable) if defined?(MongoMapper::Document)
			end

			def self.data_mapper
				DataMapper::Resource.send(:include, Monetizable) if defined?(DataMapper::Resource)
			end

			def self.sequel
				Sequel::Model.send(:include, Monetizable) if defined?(Sequel::Model)
			end			
	  end
	end
end