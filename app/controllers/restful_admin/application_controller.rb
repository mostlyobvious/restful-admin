module RestfulAdmin
  class ApplicationController < ActionController::Base
    layout 'restful_admin'
    helper_method :object_string, :collection_string

    protected
    def collection_string
      params[:resource].pluralize # ensure pluralization
    end

    def object_string
      collection_string.singularize if collection_string
    end
  end
end
