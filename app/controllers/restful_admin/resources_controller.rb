module RestfulAdmin
  class ResourcesController < ApplicationController
    before_filter :set_current_object, :only => [:show, :edit, :update, :destroy]
    before_filter :set_current_model_form_fields, :only => [:new, :edit, :update, :create]
    before_filter :set_current_model_columns, :only => [:index, :show]
    helper_method :current_collection_url, :current_object_url, :current_model

    responders :flash
    respond_to :html, :xml, :json

    def index
      @objects = current_model.order(RestfulAdmin.options[:default_index_sort_order]).paginate(:page => params[:page])
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
      @current_object.save
      respond_with(@current_object) do |format|
        format.html do
          if @current_object.valid?
            redirect_to params[:_save_and_add] ? new_resource_path : current_collection_url
          else
            render :new
          end
        end
      end
    end

    def edit
      respond_with(@current_object)
    end

    def update
      @current_object.update_attributes(params_hash)
      respond_with(@current_object) do |format|
        format.html do
          if @current_object.valid?
            params[:_save_and_continue] ? render(:edit) : redirect_to(current_collection_url)
          else
            render :edit
          end
        end
      end
    end

    def destroy
      @current_object.destroy
      respond_with(@current_object) do |format|
        format.html { redirect_to current_collection_url }
      end
    end

    def current_object_url(object, action = :show)
      self.send("#{action}_resource_path", object_string, object.id)
    end

    def current_collection_url
      self.send("resources_path", collection_string)
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

    def set_current_model_columns
      @current_model_columns = current_model.restful_admin_column_names
    end

    def set_current_model_form_fields
      @current_model_form_fields = current_model.restful_admin_form_field_names
    end

    def find_object(id)
      current_model.find(id)
    end
  end
end
