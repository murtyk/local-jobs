require 'rails_helper'

describe 'Job Search' do
  it 'finds jobs from all job boards' do
    visit root_path
    VCR.use_cassette('job_searches') do
      fill_in 'q_location', with: 'Philadelphia,PA'
      fill_in 'q_keywords', with: 'ruby rails'
      click_on 'Search'

      expect(page).to have_text 'Authentic (3)'
      expect(page).to have_text 'Indeed (71)'

      expect(page).to have_text 'Software Engineer: Delighted'
      expect(page).to have_text 'Ruby on Rails Developer: Artech Information System LLC'

      click_link 'next-button'
      expect(page).to have_text 'Web Development Instructor: The New York Code + Design Academy'
    end
  end
end
