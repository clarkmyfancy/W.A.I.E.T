require 'test_helper'

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get preferences" do
    get preferences_preferences_url
    assert_response :success
  end

end
