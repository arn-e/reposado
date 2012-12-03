require 'spec_helper'

feature "users can see a field for entering a GitHub repo to analyze" do
  scenario "user visits home page" do
    visit root_path
    page.should have_field "repo"
    page.should have_button 'Submit'
  end
end

feature "users are taken to the appropriate page after submitting GitHub repo for analysis" do
  FactoryGirl.create(:repository)

  context "GitHub repo is valid" do
    scenario "user submits URL for a repo that is already in the database" do
      # visit root_path
      # fill_in 'repo', with: "https://github.com/rails/rails"
      # click_button 'Submit'
      # current_path should eq root_path
      # page.should have_content "Rails"
    end

    scenario "user submits URL for a repo that is not in the database" do
      # visit root_path
      # fill_in 'repo', with: "https://github.com/reposado/reposado"
      # click_button 'Submit'
      # current_path should eq root_path
      # page.should have_content "We haven't analyzed that repo yet! Check back in 10."
    end
  end

  context "when GitHub repo URL is not valid" do
      # visit root_path
      # fill_in 'repo', with: "htt://github.com/jnicklas/capybara"
      # click_button 'Submit'
      # current_path should eq root_path
      # page.should have_content "Please enter a valid URL or repo name"
  end
end

feature "users can click a link to browse the library of available repos" do
  scenario "on the index view" do
    visit root_path
    page.should have_content "Browse"
  end
end

feature "users can see links to the six most recent repos" do
  pending
end

feature "users can view charts and graphs for repos in the database" do
  context "viewing a single repo" do
  end
end