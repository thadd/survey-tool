require 'spec_helper'

describe "Sessions" do
  context "When not logged in" do
    describe "GET / (Home page when logged out)" do
      it "should have login in the navbar" do
        visit root_path
        page.should have_link("Login")
      end

      it "should not have a link to home in the navbar" do
        visit root_path
        page.should have_no_link("WorkplaceResearch.org Surveys")
      end
    end

    describe "Logging in" do
      it "should successfully log in using Google Omniauth" do
        login_with_oauth

        visit root_path
        page.should have_link("John Doe")
      end
    end
  end

  context "When logged in" do
    before(:each) do
      login_with_oauth
    end

    it "should successfully log user out" do
      visit root_path
      click_link("Log out")
      page.should have_link("Login")
    end
  end
end
