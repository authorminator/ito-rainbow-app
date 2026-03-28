require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rounds_create_url
    assert_response :success
  end

  test "should get submit_clue" do
    get rounds_submit_clue_url
    assert_response :success
  end

  test "should get go_later" do
    get rounds_go_later_url
    assert_response :success
  end

  test "should get done_arranging" do
    get rounds_done_arranging_url
    assert_response :success
  end

  test "should get reveal" do
    get rounds_reveal_url
    assert_response :success
  end
end
