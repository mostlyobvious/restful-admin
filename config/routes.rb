RestfulAdmin::Engine.routes.draw do
   root :to => "home#index"

   scope :controller => "resources" do
     get ':resource(.:format)', :action => 'index'
     get ':resource/:id(.:format)', :action => 'show'
     get ':resource/new(.:format)', :action => 'new'
     post ':resource(.:format)', :action => 'create'
     get ':resource/:id/edit(.:format)', :action => 'edit'
     put ':resource/:id(.:format)', :action => 'update'
     delete ':resource/:id(.:format)', :action => 'delete'
   end
end
