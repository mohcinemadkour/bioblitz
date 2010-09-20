require 'test_helper'

class VisualizationControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
