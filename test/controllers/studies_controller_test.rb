require 'test_helper'

class StudiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @study = studies(:one)
  end

  test "should get index" do
    get studies_url
    assert_response :success
  end

  test "should get new" do
    get new_study_url
    assert_response :success
  end

  test "should create study" do
    assert_difference('Study.count') do
      post studies_url, params: { study: { description: @study.description, name: @study.name, url: @study.url, visibility: @study.visibility } }
    end

    assert_redirected_to study_url(Study.last)
  end

  test "should show study" do
    get study_url(@study)
    assert_response :success
  end

  test "should get edit" do
    get edit_study_url(@study)
    assert_response :success
  end

  test "should update study" do
    patch study_url(@study), params: { study: { description: @study.description, name: @study.name, url: @study.url, visibility: @study.visibility } }
    assert_redirected_to study_url(@study)
  end

  test "should destroy study" do
    assert_difference('Study.count', -1) do
      delete study_url(@study)
    end

    assert_redirected_to studies_url
  end
end
