RestfulAdmin::Engine.routes.draw do
   root :to => "home#index"

   controller :resources do
     get ':resource(.:format)', :to => :index, :as => 'resources'
     get ':resource/:id(.:format)', :to => :show
     get ':resource/new(.:format)', :to => :new
     post ':resource(.:format)', :to => :create
     get ':resource/:id/edit(.:format)', :to => :edit
     put ':resource/:id(.:format)', :to => :update
     delete ':resource/:id(.:format)', :to => :delete
   end
end
