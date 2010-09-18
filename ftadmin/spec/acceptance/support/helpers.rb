module HelperMethods
  def peich
    save_and_open_page
  end
  
  def enable_javascript
    Capybara.current_driver = :selenium
  end
  
  def darwin
    User.where('name' => 'Darwin').first || create_user
  end
  
  def login_as(user)
    fill_in('email', :with => user.email)
    fill_in('password', :with => user.password)
    click_button('Log in')
  end
end

Rspec.configuration.include(HelperMethods)
