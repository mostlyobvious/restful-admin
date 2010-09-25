require 'restful_admin/engine'
# require external libraries here unless we have access to main apps Gemfile
require 'will_paginate'
require 'simple_form'

module RestfulAdmin
  @@resources = Set.new
  @@options = {
    :save_label => "Save",
    :save_and_continue_label => "Save and continue editing",
    :save_and_add_label => "Save and add another",
    :new_label => "+ Add",
    :show_label => "Show",
    :edit_label => "Edit",
    :destroy_label => "Delete",
    :destroy_confirm => "Are you sure want to destroy this record?",
    :default_index_action => :edit,
    :default_index_sort_order => 'created_at DESC'
  }
  mattr_reader :options

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
        @options[:edit_link_columns] = %w{id}
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
      RestfulAdmin.register(self)
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

    def restful_admin_form_field_names
      self.columns.select { |col| !(col.type == :binary || %w{id updated_at created_at}.include?(col.name)) }.collect(&:name)
    end

    def restful_admin_edit_link_column_names
      @@restful_admin_options[:edit_link_columns]
    end
  end

  module Initializer
    def self.load_models(models_path)
      Dir[models_path.join('*.rb')].map { |f| File.basename(f, '.*').camelize.constantize }
    end
  end
end

ActiveRecord::Base.send(:include, RestfulAdmin::Base)
