require 'capybara/rails'
require 'capybara/rspec'

Capybara.save_and_open_page_path = ENV['CAPYBARA_PAGE_PATH'] || 'public/tmp'
