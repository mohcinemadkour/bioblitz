module NavigationHelpers
  # Put here the helper methods related to the paths of your applications
  
  def homepage
    "/"
  end
  
  def taxonomizer
    "/taxonomizer"
  end
end

Rspec.configuration.include(NavigationHelpers)
