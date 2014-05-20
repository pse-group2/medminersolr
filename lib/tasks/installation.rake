require 'treat'

namespace :installation do
   
  task :install_german => :environment do
    Treat::Core::Installer.install 'german'
  end
  
  task :sunspot do
    system 'rails generate sunspot_rails:install'
  end
  
end
