require 'rails_helper'

feature 'pictures' do
  context 'no pictures exist' do
    scenario 'should display a prompt to add a picture' do
      visit '/'
      expect(page).to have_content 'No pictures yet'
    end
  end

  context 'adding pictures with location' do
    scenario 'user can add a picture and see it on the home page with address information' do
      visit '/'
      sign_up
      click_link 'Post a picture'
      attach_file('picture[image]', File.absolute_path('./spec/test_images/cat.jpg'))
      click_button 'Create Picture'
      expect(page).to have_css("img[@alt=Cat]")
      expect(page).to have_content("Lincolnshire, GB")
    end
  end

  context 'adding pictures without location' do
    scenario 'user can add a picture and see it on the home page with address information' do
      visit '/'
      sign_up
      click_link 'Post a picture'
      attach_file('picture[image]', File.absolute_path('./spec/test_images/cat_no_gps.jpg'))
      click_button 'Create Picture'
      expect(page).to have_css("img[@alt='Cat no gps']")
    end
  end

  context 'commenting on a picture' do
    scenario 'signed-in users can add a comment to a picture and see it on the home page' do
      visit '/'
      sign_up
      click_link 'Post a picture'
      attach_file('picture[image]', File.absolute_path('./spec/test_images/cat_no_gps.jpg'))
      click_button 'Create Picture'
      click_link 'Comment'
      fill_in 'comment_content', with: 'Great!'
      click_button 'Create Comment'
      expect(current_path).to eq '/pictures'
      expect(page).to have_content('test@example.com: Great!')
      expect(page).to have_css("img[@alt='Cat no gps']")
    end

    scenario 'random visitors cannot add a comment to a picture' do
      visit '/'
      sign_up
      click_link 'Post a picture'
      attach_file('picture[image]', File.absolute_path('./spec/test_images/cat_no_gps.jpg'))
      click_button 'Create Picture'
      click_link 'Sign out'
      expect(current_path).to eq '/'
      expect(page).to have_content 'Sign in'
      expect(page).to have_content 'Sign up'
      expect(page).to have_css("img[@alt='Cat no gps']")
      expect(page).not_to have_link 'Post a picture'
    end
  end


end
