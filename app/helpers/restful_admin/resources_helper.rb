require 'auto_excerpt'

module RestfulAdmin
  module ResourcesHelper
    def resource_name
      current_model.model_name.human
    end

    def resources_name
      current_model.model_name.human(:count => 2)
    end

    def resource_attribute_name(column_name)
      current_model.human_attribute_name(column_name)
    end

    def resource_attribute_value(object, column_name, options = {})
      value = object.send(column_name)
      column = current_model.columns_hash[column_name]
      output = if column
        case column.type
        when :datetime
          datetime_value(value, column_name, options)
        when :text, :string           
          string_value(value, column_name, options)
        when :boolean
          boolean_value(value, column_name, options)
        else
          value
        end
      else
        if [true, false].include?(value)
          boolean_value(value, column_name, options)
        else
          value
        end
      end
      if options[:linkify] && current_model.restful_admin_linkified_column_names.include?(column_name)
        linkify_value(object, output)
      else
        output
      end
    end

    def resource_edit_link
      link_to RestfulAdmin.options[:edit_label], edit_resource_path, :class => 'button' 
    end

    def resource_show_link
      link_to RestfulAdmin.options[:show_label], show_resource_path, :class => 'button' 
    end

    def resource_destroy_link
      link_to RestfulAdmin.options[:destroy_label], destroy_resource_path, :class => 'button', :method => 'delete', :confirm => RestfulAdmin.options[:destroy_confirm]
    end

    private
    def datetime_value(value, column_name, options = {})
      I18n.l(value)
    end

    def string_value(value, column_name, options = {})
      if options[:formatted] && formatter = current_model.restful_admin_formatted_column_names[column_name]
        value = send(formatter, value).html_safe
      end
      if options[:excerpt] && excerpt_options = current_model.restful_admin_excerpted_column_names[column_name]
        value = AutoExcerpt.new(value, excerpt_options.symbolize_keys)
      end
      value
    end

    def boolean_value(value, column_name, options = {})
      value ? image_tag('icon-yes.gif') : image_tag('icon-no.gif')
    end

    def linkify_value(object, value)
      link_to(value, current_object_url(object, RestfulAdmin.options[:default_index_action])) 
    end
  end
end
