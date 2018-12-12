require 'test_helper'

class SaleSupportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sale_supports_index_url
    assert_response :success
  end

end
