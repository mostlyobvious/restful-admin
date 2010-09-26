require 'app_responder'

module RestfulAdmin
  class ApplicationController < ActionController::Base
    self.responder = AppResponder

    layout 'restful_admin'
    helper_method :object_string, :collection_string

    protected
    def collection_string
      params[:resource].try(:pluralize) # ensure pluralization
    end

    def object_string
      collection_string.try(:singularize)
    end
  end
end
