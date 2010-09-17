require 'restful_admin/engine'

module RestfulAdmin
  @@resources = Set.new

  def self.resources
    @@resources.to_a
  end

  def self.register(model)
    @@resources << model.model_name
  end

  module Base
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    class Configuration
      def initialize(options = {})
        @options = options
      end
      
      def method_missing(method, args)
        @options[method.to_sym] = args
      end
  
      def [](option)
        @options[option]
      end
    end
  end

  module ClassMethods
    def restful_admin(&block)
      RestfulAdmin.register(self) unless defined?(@@restful_admin_options)
      @@restful_admin_options = RestfulAdmin::Base::Configuration.new
      yield @@restful_admin_options if block_given?
    end

    def restful_admin_column_names
      initial_columns = self.columns.select { |col| col.type != :binary }.collect(&:name)
      if only = @@restful_admin_options[:columns_only]
        only_set, initial_set = [*only].to_set, initial_columns.to_set
        columns = (initial_set & only_set) + (only_set - initial_set)
      elsif except = @@restful_admin_options[:columns_except]
        except_set, initial_set = [*except].to_set, initial_columns.to_set
        columns = initial_set - except_set
      else
        columns = initial_columns
      end
      columns + @@restful_admin_options[:columns_additional].to_a
    end
  end

  module Initializer
    def self.load_models(models_path)
      Dir[models_path.join('*.rb')].map { |f| File.basename(f, '.*').camelize.constantize }
    end
  end
end

ActiveRecord::Base.send(:include, RestfulAdmin::Base)
