require 'spec_helper'

feature "users can see a field for entering a GitHub repo to analyze" do
  scenario "generic" do
    visit root_path
    page.should have_field "GitHub repo"
  end
end

feature "users can see a button for submitting a GitHub repo for analysis" do
  scenario "generic" do
    visit root_path
    page.should have_button 'Submit'
  end
end

feature "users are taken to the appropriate page after submitting GitHub repo for analysis" do
  scenario "GitHub repo is valid" do
    scenario "user submits URL" do
      visit root_path
      fill_in 'Repo', with: "http://github.com/jnicklas/capybara"
      # NEED FEEDBACK FROM TEAM ON ROUTING HERE
      current_path.should eq new_repo_path
    end

    scenario "user submits repo name" do
      visit root_path
      fill_in 'Repo', with: "capybara"
      # NEED FEEDBACK FROM TEAM ON ROUTING HERE
      current_path.should eq new_repo_path
    end
  end

  scenario "GitHub repo is not valid" do
    scenario "user submits URL" do
      visit root_path
      fill_in 'Repo', with: "htt://github.com/jnicklas/capybara"
      # NEED FEEDBACK FROM TEAM ON ROUTING HERE
      current_path.should eq root_path
    end

    scenario "user submits repo name" do
      visit root_path
      fill_in 'Repo', with: "caypbara"
      # NEED FEEDBACK FROM TEAM ON ROUTING HERE
      current_path.should eq root_path
    end
  end
end

# feature "users are alerted when the submitted repo is not valid" do
#   pending
# end
