require 'treat'
namespace :prepare_treat do
task :install_german => :environment do
  Treat::Core::Installer.install 'german'
  end
end