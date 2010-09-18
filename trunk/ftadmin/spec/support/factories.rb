module Factories
  def create_user(attrs = {})
    attrs[:name]                  ||= 'Darwin'
    attrs[:email]                 ||= 'charles.darwin@bioblizt.com'
    attrs[:password]              ||= 'secret'
    attrs[:password_confirmation] ||= 'secret'
    User.create!(attrs)
  end
end

RSpec.configure {|config| config.include(Factories)} 