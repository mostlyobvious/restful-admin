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
  end

  module Initializer
    def self.load_models(models_path)
      Dir[models_path.join('*.rb')].map { |f| File.basename(f, '.*').camelize.constantize }
    end
  end
end

ActiveRecord::Base.send(:include, RestfulAdmin::Base)
