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
      if column = current_model.columns_hash[column_name]
        column_value = case column.type
        when :datetime
          I18n.l(value)
        when :text, :string           
          options[:excerpt] ? AutoExcerpt.new(value) : value
        when :boolean
          value ? image_tag('icon-yes.gif') : image_tag('icon-no.gif')
        else
          value
        end
        if options[:linkify] && current_model.restful_admin_edit_link_column_names.include?(column.name)
          link_to(column_value, current_object_url(object, RestfulAdmin.options[:default_index_action])) 
        else
          column_value
        end
      else
        if [true, false].include?(value)
          value ? image_tag('icon-yes.gif') : image_tag('icon-no.gif')
        else
          value
        end
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
  end
end
