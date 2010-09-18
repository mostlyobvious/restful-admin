module RestfulAdmin
  class ResourcesController < ApplicationController
    before_filter :set_current_object, :only => [:show, :edit, :update, :destroy]
    helper_method :current_collection_url, :current_object_url, :current_model

    respond_to :html, :xml, :json

    def index
      @objects = current_model.paginate(:page => params[:page])
      @current_model_columns = current_model.restful_admin_column_names
      instance_variable_set("@#{collection_string}", @objects)
      respond_with(@objects)
    end

    def show
      respond_with(@current_object)
    end

    def new
      @current_object = current_model.new(params_hash)
      instance_variable_set("@#{object_string}", @current_object)
      respond_with(@current_object)
    end

    def create
      @current_object = current_model.new(params_hash)
      instance_variable_set("@#{object_string}", @current_object)
      flash[:notice] = "Created successfully" if @current_object.save
      respond_with(@current_object) do |format|
        format.html { redirect_to current_collection_url }
      end
    end

    def edit
      respond_with(@current_object)
    end

    def update
      flash[:notice] = "Updated successfully" if @current_object.update_attributes(params_hash)
      respond_with(@current_object) do |format|
        format.html { redirect_to current_collection_url }
      end   
    end

    def destroy
      @current_object.destroy
      flash[:notice] = "Deleted successfully"
      respond_with(@current_object) do |format|
        format.html { redirect_to current_collection_url }
      end
    end

    def current_object_url(object)
      self.send("#{object_string}_path", object.id)
    end

    def current_collection_url
      self.send("#{collection_string}_path")
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
