# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AmethystSprites::Application.initialize!

ENV['S3_BUCKET'] = "#{Rails.env}.sprites.amethyst.smogon.com"