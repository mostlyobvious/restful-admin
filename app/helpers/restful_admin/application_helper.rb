module RestfulAdmin
  module ApplicationHelper
    def resources_menu
      content_tag(:ul) do
        RestfulAdmin.resources.collect do |model_name|
          concat(content_tag(:li, link_to(model_name.human(:count => 2), model_name.underscore.pluralize)))
        end
      end
    end
  end
end
