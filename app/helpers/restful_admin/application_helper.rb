module RestfulAdmin
  module ApplicationHelper
    def resources_menu
      content_tag(:ul) do
        RestfulAdmin.resources.collect do |model_name|
          selected = (object_string == model_name.underscore) ? "selected" : nil
          concat(content_tag(:li, link_to(model_name.human, resources_path(:resource => model_name.underscore.pluralize)), :class => selected))
        end
      end
    end
  end
end
