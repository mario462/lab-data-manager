require "application_system_test_case"

class DatasetsTest < ApplicationSystemTestCase
  setup do
    @dataset = datasets(:one)
  end

  test "visiting the index" do
    visit datasets_url
    assert_selector "h1", text: "Datasets"
  end

  test "creating a Dataset" do
    visit datasets_url
    click_on "New Dataset"

    click_on "Create Dataset"

    assert_text "Dataset was successfully created"
    click_on "Back"
  end

  test "updating a Dataset" do
    visit datasets_url
    click_on "Edit", match: :first

    click_on "Update Dataset"

    assert_text "Dataset was successfully updated"
    click_on "Back"
  end

  test "destroying a Dataset" do
    visit datasets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dataset was successfully destroyed"
  end
end
