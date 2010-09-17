module RestfulAdmin
  class Engine < ::Rails::Engine
    namespace RestfulAdmin

    initializer "restful_admin.load_models" do
      RestfulAdmin::Initializer.load_models(Rails.root.join("app", "models"))
    end
  end
end
