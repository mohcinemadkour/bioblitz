require File.dirname(__FILE__) + '/acceptance_helper'

feature "Taxonomizer", %q{
  In order to catalog species
  As a user
  I want taxonomizer helps me to identify them
} do
  
  context 'Taxonomers' do
    scenario "can identify a species" do
      visit taxonomizer
      login_as darwin
      fill_in('text_input', :with => 'Puma co')
      page.should have_css('.ac_results')
      within('.ac_results ul li:first-child') do
        page.should have_css('p', :text => 'Puma co')
      end
      assert_difference "Identification.all.length" do
        page.execute_script("$('.ac_results ul li:contains(Puma concolor)').mouseenter().click();")
        find_field('text_input').value.should eq('Enter scientific name here')
      end
    end

  end
  
end