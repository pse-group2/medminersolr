# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Medminer::Application.initialize!
ActiveRecord::Base.logger.level = 1