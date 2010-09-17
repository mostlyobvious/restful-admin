module RestfulAdmin
  class ResourcesController < ApplicationController
    before_filter :set_current_object, :only => [:show, :edit, :update, :destroy]
    helper_method :current_collection_url, :current_object_url, :object_string, :collection_string, :current_model

    respond_to :html, :xml, :json

    def index
      @objects = current_model.paginate(:page => params[:page])
      @current_model_columns = current_model.restful_admin_column_names
      instance_variable_set("@#{collection_string}", @objects)
      respond_with(@objects)
    end

    def current_object_url(object)
      self.send("#{object_string}_path", object.id)
    end

    def current_collection_url
      self.send("#{collection_string}_path")
    end

    def collection_string
      params[:resource]
    end

    def object_string
      collection_string.singularize
    end

    def current_model
      Object.const_get(object_string.classify)
    end
    
    protected
    def params_hash
      params[object_string.to_sym]
    end
    
    def set_current_object
      @current_object = instance_variable_set("@#{object_string}", find_object(params[:id]))
    end

    def find_object(id)
      current_model.find(id)
    end
  end
end
