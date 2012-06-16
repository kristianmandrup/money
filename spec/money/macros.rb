class Money
  module Macros
    def self.macros
      [:value, :price, :cost]
    end

    macros.each do |klass|
      name = "#{klass}_class"

      # define getter
      define_singleton_method name do
        var_name = :"@#{name}"
        unless instance_variable_get(var_name)
          instance_variable_set(var_name, klass.to_s.camelize.constantize)
        end
        instance_variable_get(var_name)
      end
    end

    class << self
      Moneys::Macros.macros.each do |name|
        writ_klass = "#{name}_class"
        # define attr writer
        self.send(:attr_writer, writ_klass)
      end

      def classes= klass
        macros.each {|m| send("#{m.to_s.underscore}_class=", klass) }
      end

      def macro_map
        {
          :costing => :cost,
          :priced_at => :price,
          :valued_at => :value
        }
      end
    end
  end
end