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

    def resource_attribute_value(object, column_name)
      value = object.send(column_name)
      if column = current_model.columns_hash[column_name]
        case column.type
        when :datetime
          I18n.l(value)
        when :text, :string
          AutoExcerpt.new(value)
        when :boolean
          value ? image_tag('icon-yes.gif') : image_tag('icon-no.gif')
        else
          value
        end
      else
        if [true, false].include?(value)
          value ? image_tag('icon-yes.gif') : image_tag('icon-no.gif')
        else
          value
        end
      end
    end
  end
end
