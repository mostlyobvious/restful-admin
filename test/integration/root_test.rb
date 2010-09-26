require 'test_helper'

class RootTest < ActiveSupport::IntegrationCase
  test "I can see title on root page" do
    visit restful_admin.root_path
    assert page.has_content?("RestfulAdmin")
  end

  test "I can see resources links on root page" do
    visit restful_admin.root_path
    assert page.has_link?("Post")
  end
end
