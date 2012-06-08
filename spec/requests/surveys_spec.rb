require 'spec_helper'

describe "Surveys" do
  before(:each) do
    login_with_oauth
    @user = User.where(email: "user@example.com").first
  end

  describe "Listing surveys" do
    it "should show a blank slate with no surveys" do
      visit root_path
      page.should have_content("You haven't created any surveys yet")

      @user.surveys.create!(name: "Testing")

      visit root_path
      page.should have_link("Add survey")
    end

    it "should list all of the current users surveys" do
      first = @user.surveys.create!(name: "First")
      second = @user.surveys.create!(name: "Second")
      third = @user.surveys.create!(name: "Third")

      visit root_path
      ids = page.all("#survey-list li").collect{|e|e[:id]}
      ids.sort.should eq([first, second, third].map{|e| "survey_#{e.id}"}.sort)
    end

    it "should not list surveys owned by other users" do
      @another_user = User.create!(name: "Not John Doe", email: "not_user@example.com")

      user_first = @user.surveys.create!(name: "First")
      another_user_first = @another_user.surveys.create!(name: "First")

      visit root_path
      ids = page.all("#survey-list li").collect{|e|e[:id]}
      ids.should eq(["survey_#{user_first.id}"])
    end
  end

  describe "Create new survey" do
    before(:each) do
      visit new_survey_path
      fill_in 'Name', with: 'Testing'
    end

    it "should return to the index after saving" do
      click_on "Save"
      current_path.should eq(root_path)
    end

    it "should come back to the current page if you save and continue editing" do
      click_on "Save and continue editing"
      current_path.should eq(edit_survey_path(@user.surveys.first))
    end

    it "should show the preview when requested" do
      click_on "Save and preview"
      current_path.should eq(preview_survey_path(@user.surveys.first))
    end

    it "should cancel without saving when requested" do
      click_on "Cancel"
      current_path.should eq(root_path)
      @user.surveys.count.should eq(0)
    end
  end

  describe "Showing dependencies in preview" do
    before(:each) do
      @xml = IO.read("#{Rails.root}/spec/fixtures/files/simple_survey.xml")
      @survey = @user.surveys.create!(name: 'Testing', xml: @xml)
      visit preview_survey_path(@survey)
    end

    it "should show page dependencies" do
      page.should have_selector("#page-1 h2 small", text: "Dependent on q1 having value skip page")
    end

    it "should show a dependency for a question on a subsequent page" do
      page.should have_selector("#page-1 .dependent[@title='Dependent on q1 having value skip q2'] #response_page_answers_q2")
    end
  end
end
