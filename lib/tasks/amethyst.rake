namespace :amethyst do
  desc "Clear Pokemon gallery cache"
  task :clear_cache => :environment do
    c = ActionController::Base.new
    Pokemon.all.each{|p| c.expire_fragment(p)}
  end
end