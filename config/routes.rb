RestfulAdmin::Engine.routes.draw do
   root :to => "home#index"

   controller :resources do
     get ':resource(.:format)', :to => :index, :as => 'resources'
     get ':resource/new(.:format)', :to => :new, :as => 'new_resource'
     get ':resource/:id(.:format)', :to => :show, :as => 'show_resource'
     post ':resource(.:format)', :to => :create
     get ':resource/:id/edit(.:format)', :to => :edit, :as => 'edit_resource'
     put ':resource/:id(.:format)', :to => :update
     delete ':resource/:id(.:format)', :to => :destroy, :as => 'destroy_resource'
   end
end
